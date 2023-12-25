function picker
    for option in $argv
        set index (contains -i $option $argv)
        set indexed[$index] "$index: $option"
    end

    printf %s\n $indexed | fzf --print0 | string split ": " -f2
end
