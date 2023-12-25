set -gx PAGER less
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

fish_add_path $HOME/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.local/share/bob/nvim-bin

. $HOME/bin/start-agent.fish

rtx activate fish | source
zoxide init fish | source

function l
    ls -lah $argv
end
