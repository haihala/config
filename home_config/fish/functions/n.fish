function __n_dir --description "Root directory for notes"
    if set -q NOTES_DIR
        echo $NOTES_DIR
    else
        echo $HOME/notes
    end
end

function __n_titlecase --description "'sprint-planning' -> 'Sprint Planning'"
    set -l words (string split -n -- ' ' (string replace -ar -- '[-_]+' ' ' "$argv"))
    set -l capitalized

    for word in $words
        set -a capitalized (string upper (string sub -l 1 -- $word))(string sub -s 2 -- $word)
    end

    string join -- ' ' $capitalized
end

function __n_edit --description "Open a note, placing the cursor on the last line"
    switch (basename $EDITOR)
        case vi vim nvim
            $EDITOR $argv[1] '+$'
        case '*'
            $EDITOR $argv[1]
    end
end

function __n_list --description "Existing notes, as paths relative to the notes dir, without .md"
    set -l dir (__n_dir)

    if type -q fd
        fd --type file --extension md . $dir
    else
        find $dir -type f -name '*.md'
    end | string replace -- "$dir/" '' | string replace -r -- '\.md$' '' | sort
end

function __n_open --description "Open a note by name, creating it if it does not exist"
    set -l name (string trim -- "$argv")
    test -z "$name"; and return 1

    set -l dir (__n_dir)
    set -l file $dir/(string replace -r -- '\.md$' '' $name).md

    # Anything that isn't already a note becomes a new, slugified note in the root
    if not test -f $file
        set -l slug (string lower -- $name | sed -E 's/[^a-zA-Z0-9]+/-/g; s/^-+//; s/-+$//')
        test -z "$slug"; and return 1

        set file $dir/$slug.md
        mkdir -p $dir
        if not test -f $file
            printf '# %s\n\n\n' (__n_titlecase $slug) >$file
        end
    end

    __n_edit $file
end

function __n_meeting --description "Open today's meeting note of the given type"
    set -l slug (string lower -- "$argv" | sed -E 's/[^a-zA-Z0-9]+/-/g; s/^-+//; s/-+$//')
    test -z "$slug"; and return 1

    set -l date (date -Idate)
    set -l dir (__n_dir)/meeting-notes
    set -l file $dir/$date-$slug.md

    mkdir -p $dir
    if not test -f $file
        printf '# %s %s\n\n\n' (__n_titlecase $slug) $date >$file
    end

    __n_edit $file
end

function __n_meeting_type --description "Pick an existing meeting type, or type a new one"
    set -l dir (__n_dir)/meeting-notes
    set -l types

    if test -d $dir
        set types (
            for file in $dir/*.md
                string replace -r -- '^\d{4}-\d{2}-\d{2}-' '' (basename $file .md)
            end | sort -u
        )
    end

    printf '%s\n' $types |
        fzf --print-query --prompt 'meeting type> ' |
        tail -n 1
end

function n --description "Take and find notes in ~/notes"
    argparse -X 1 h/help m/meeting -- $argv
    or return

    if set -q _flag_help
        echo 'Usage: n [OPTION] [NAME]

  n                  Pick a note to open, or type a name to create a new one
  n NAME             Open note NAME, creating it if it does not exist
  n -m [TYPE]        Open today\'s TYPE meeting note, creating it if needed
  n -h               Show this help

Notes live in ~/notes, override with the NOTES_DIR environment variable.
Meeting notes are stored as meeting-notes/YYYY-MM-DD-type.md'
        return
    end

    if set -q _flag_meeting
        set -l type $argv[1]
        test -z "$type"; and set type (__n_meeting_type)
        __n_meeting "$type"
        return
    end

    if test -n "$argv[1]"
        __n_open "$argv[1]"
        return
    end

    set -l dir (__n_dir)
    set -l preview 'head -n 500'
    type -q bat; and set preview 'bat --style=numbers --color=always --line-range :500'

    __n_open (
        __n_list |
        fzf --print-query --prompt 'note> ' --preview "$preview $dir/{}.md" |
        tail -n 1
    )
end
