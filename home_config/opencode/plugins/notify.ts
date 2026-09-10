import type { Plugin } from "@opencode-ai/plugin"

/** Only notify for turns that took at least this long. */
const THRESHOLD_MS = Number(process.env.OPENCODE_NOTIFY_THRESHOLD_MS ?? 60_000)

export const NotifyPlugin: Plugin = async ({ $, client, worktree }) => {
  const project = worktree?.split("/").pop() ?? "opencode"

  /** sessionID -> start of the current turn */
  const started = new Map<string, number>()
  /** sessions whose current turn the user cancelled */
  const aborted = new Set<string>()
  /** sessionID -> is this a Task-tool child session */
  const isChild = new Map<string, boolean>()

  const session = async (sessionID: string) => {
    try {
      const res: any = await client.session.get({ path: { id: sessionID } })
      return res?.data ?? res
    } catch {
      return undefined
    }
  }

  const isChildSession = async (sessionID: string) => {
    const cached = isChild.get(sessionID)
    if (cached !== undefined) return cached
    const child = Boolean((await session(sessionID))?.parentID)
    isChild.set(sessionID, child)
    return child
  }

  /** Session titles are generated and can be long; keep them toast-sized. */
  const truncate = (s: string, max = 48) => (s.length > max ? s.slice(0, max - 1).trimEnd() + "\u2026" : s)

  const notify = async (sessionID: string | undefined, message: string, sound: string) => {
    // Fetched fresh: the title is auto-generated and changes as a session evolves.
    const name = sessionID ? (await session(sessionID))?.title : undefined
    const script = [
      `display notification ${JSON.stringify(message)}`,
      `with title ${JSON.stringify(`opencode \u00b7 ${project}`)}`,
      `subtitle ${JSON.stringify(truncate(name ?? "session"))}`,
      `sound name "${sound}"`,
    ].join(" ")
    await $`osascript -e ${script}`.quiet().nothrow()
  }

  const humanize = (ms: number) => {
    const s = Math.round(ms / 1000)
    if (s < 90) return `${s}s`
    const m = Math.floor(s / 60)
    return m < 60 ? `${m}m ${s % 60}s` : `${Math.floor(m / 60)}h ${m % 60}m`
  }

  return {
    "chat.message": async ({ sessionID }) => {
      if (!sessionID) return
      if (await isChildSession(sessionID)) return
      started.set(sessionID, Date.now())
      aborted.delete(sessionID)
    },

    event: async ({ event }) => {
      // The plugin package's `Event` union lags the running server, so match on
      // the raw string and read `properties` loosely.
      const type: string = event.type
      const props: any = (event as any).properties ?? {}

      // Blocking on the user: always worth a toast, whatever the elapsed time.
      if (type === "permission.asked" || type === "permission.updated") {
        await notify(props.sessionID, "Needs permission", "Funk")
        return
      }

      if (type === "question.asked") {
        await notify(props.sessionID, props.questions?.[0]?.header ?? "Needs input", "Funk")
        return
      }

      if (type === "session.error") {
        // A user-initiated cancel surfaces as MessageAbortedError. They are by
        // definition present, so suppress it and the session.idle that follows.
        if (props.error?.name === "MessageAbortedError") {
          if (props.sessionID) aborted.add(props.sessionID)
          return
        }
        await notify(props.sessionID, props.error?.name ?? "Session error", "Basso")
        return
      }

      if (type === "session.idle") {
        const sessionID: string = props.sessionID
        const start = started.get(sessionID)
        started.delete(sessionID)

        if (aborted.delete(sessionID)) return
        if (start === undefined) return // child session, or a turn we never saw start
        const elapsed = Date.now() - start
        if (elapsed < THRESHOLD_MS) return

        await notify(sessionID, `Done in ${humanize(elapsed)}`, "Glass")
      }
    },
  }
}
