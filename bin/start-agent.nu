#!/usr/bin/env nu
let sshAgentFilePath = $"/tmp/ssh-agent-($env.USER).nuon"

if not (($sshAgentFilePath | path exists) and ($"/proc/((open $sshAgentFilePath).SSH_AGENT_PID)" | path exists)) {
    # creating it
    ^ssh-agent -c
        | lines
        | first 2
        | parse "setenv {name} {value};"
        | transpose -r
        | into record
        | save --force $sshAgentFilePath

    load-env (open $sshAgentFilePath)

    # TODO: This could use gpg keys to better enable multi-key setups
    with-env [SSH_ASKPASS_REQUIRE "never"] { ssh-add }
} else {
    # loading it
    load-env (open $sshAgentFilePath)
}


