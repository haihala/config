function e
    if count $argv >>/dev/null
        # All arguments are passed directly to the editor, so e is short for $EDITOR
        # Only if no arguments are passed, does it start to do stuff
        $EDITOR $argv
        return
    end

    function file_in_commit
        set result (git diff-tree --no-commit-id --name-only $argv -r | 
        fzf --print0 |
        xargs -0 -o)

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
        "Search by file name (disregard .gitignore)"

    set preview_cmd 'bat --style=numbers --color=always --line-range :500 {}'

    for action in $actions
        set index (contains -i $action $actions)
        set indexed[$index] "$index: $action"
    end

    set selection (printf %s\n $indexed | fzf --print0 | cut -d ":" -f 1)

    switch $selection
        case 1
            $EDITOR
        case 2
            set result (FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix' \
                fzf --print0 --preview "$preview_cmd" | xargs -0 -o)

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
    end
end
