set -gx PAGER less
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx RUSTC_WRAPPER sccache
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

fish_add_path $HOME/bin
fish_add_path $HOME/bin/git-ignored
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/share/bob/nvim-bin
fish_add_path $HOME/.local/share/mise/shims

# bun
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# Press control-g to delete last line in history
bind \cg 'history delete --exact --case-sensitive -- $history[1]'

. $HOME/bin/start-agent.fish

mise activate fish | source
zoxide init fish | source

set -Ux fish_tmux_config $HOME/.config/tmux/tmux.conf

function l
    ls -lah $argv
end

function yoink
    wl-copy <$argv
end

function yeet
    wl-paste >$argv
end

if set -q ZELLIJ
else
    zellij
end
