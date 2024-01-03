set -gx PAGER less
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

fish_add_path $HOME/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/share/bob/nvim-bin
fish_add_path $HOME/.local/share/mise/shims

. $HOME/bin/start-agent.fish

mise activate fish | source
zoxide init fish | source

function l
    ls -lah $argv
end

function yoink
    wl-copy <$argv
end

function yeet
    wl-paste >$argv
end
