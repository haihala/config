function cfg
    set legal_targets fish sway nvim tmux readme cfg e tool git zellij

    if count $argv >>/dev/null
        set target $argv
    else
        set target (picker $legal_targets)
    end

    set fish_conf_dir (readlink $HOME/.config/fish)

    switch $target
        case fish
            $EDITOR $fish_conf_dir/config.fish
        case sway
            $EDITOR (readlink $HOME/.config/sway)/config
        case nvim vim
            $EDITOR (readlink $HOME/.config/nvim)/init.lua
        case tmux
            $EDITOR (readlink $HOME/.config/tmux)/tmux.conf
        case readme
            $EDITOR (dirname (readlink $HOME/bin))/README.md
        case cfg
            $EDITOR $fish_conf_dir/functions/cfg.fish
        case e
            $EDITOR $fish_conf_dir/functions/e.fish
        case tool
            $EDITOR (readlink $HOME/bin)/tool
        case git
            $EDITOR (readlink $HOME/.config/git)/config
        case zellij
            $EDITOR (readlink $HOME/.config/zellij)/config.kdl
        case '*'
            echo "Invalid target $target"
    end
end
