set -gx PAGER less
set -gx EDITOR nvim
set -gx VISUAL nvim

fish_add_path $HOME/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin

. $HOME/bin/start-agent.fish

rtx activate fish | source
zoxide init fish | source

function l
    ls -lah $argv
end
