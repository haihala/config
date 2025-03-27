function e
    if count $argv >>/dev/null
        # All arguments are passed directly to the editor, so e is short for $EDITOR
        # Only if no arguments are passed, does it start to do stuff
        $EDITOR $argv
        return
    end

    # If an editor is already open in this window, just re-open it
    set jobline (jobs | grep EDITOR | head -n 1)
    if test -n "$jobline"
        fg %(echo $jobline | cut -c1-1)
        return
    end

    function file_in_commit
        set selected (
            git diff-tree --no-commit-id --name-only $argv -r | 
            fzf --print0 |
            xargs -0 -o
        )

        set reporoot (git rev-parse --show-toplevel)
        set result (string join '/' $reporoot $selected)

        if test -e $result
            $EDITOR $result
        end
    end

    set actions "Just open the editor" \
        "Search by file name" \
        "Search by content" \
        "Search git status" \
        "Search previous commit changed files" \
        "Search arbitrary commit" \
        "Search by file name (disregard .gitignore)" \
        "Open previously opened file" \
        "Listen to cached pipe"

    set preview_cmd 'bat --style=numbers --color=always --line-range :500 {}'

    switch (index_picker $actions)
        case 1
            $EDITOR
        case 2
            set result (fzf --print0 --preview "$preview_cmd" | xargs -0 -o)

            if test -e $result
                $EDITOR $result
            end

        case 3
            # Fuzzy find against current folder contents, match file name, line and column
            set rg_prefix 'rg --no-heading --line-number --column --smart-case --color=always'
            set result (
                fzf --bind "start:reload:$rg_prefix ''" \
                    --bind "change:reload:$rg_prefix {q} || true" \
                    --ansi --print0 |
                    xargs -0 -o |
                    string split ':'
            )

            if test -e $result[1]
                $EDITOR $result[1] "+call cursor($result[2], $result[3])"
            end
        case 4
            set result (git status -s | 
                fzf --ansi --print0 | 
                xargs -0 -o | 
                string trim |
                string split ' ' -f2)

            if test -e $result
                $EDITOR $result
            end
        case 5
            file_in_commit HEAD
        case 6
            set commit_hash (git log --all --oneline --color=always | 
                fzf --ansi --print0 | 
                xargs -0 -o | 
                cut -d' ' -f1)
            file_in_commit $commit_hash
        case 7
            set result (fzf --print0 --preview "$preview_cmd" | xargs -0 -o)

            if test -e $result
                $EDITOR $result
            end
        case 8
            $EDITOR '+\'0'
        case 9
            set pipe_path ~/.cache/nvim/server.pipe
            if test -e $pipe_path
                echo "Pipe already exists, exiting"
            else
                $EDITOR --listen $pipe_path
            end
    end
end
