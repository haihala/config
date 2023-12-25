function cfg
    set legal_targets zsh fish sway nvim tmux zellij readme cfg e

    if count $argv >>/dev/null
        set target $argv
    else
        set target (picker $legal_targets)
    end

    set fish_conf_dir (readlink $HOME/.config/fish)

    switch $target
        case zsh
            $EDITOR (readlink $HOME/.zshrc)
        case fish
            $EDITOR $fish_conf_dir/config.fish
        case sway
            $EDITOR (readlink $HOME/.config/sway)/config
        case nvim vim
            $EDITOR (readlink $HOME/.config/nvim)/init.lua
        case tmux
            $EDITOR (readlink $HOME/.tmux.conf)
        case zellij
            $EDITOR (readlink $HOME/.config/zellij)/config.kdl
        case readme
            $EDITOR (dirname (readlink $HOME/bin))/README.md
        case cfg
            $EDITOR $fish_conf_dir/functions/cfg.fish
        case e
            $EDITOR $fish_conf_dir/functions/e.fish
        case '*'
            echo "Invalid target $target"
    end
end
