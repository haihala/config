export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="random"

HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="%c"

plugins=(autojump autopep8 cabal cake capistrano catimg chucknorris coffee docker encode64 extract gem git gitfast git-extras git-flow github jira jsontools meteor ng node npm perl perms pip python rand-quote repo ruby scala sudo systemd vscode wd z)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"

# Path updates
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cache/activestate/bin:$PATH"
export PATH="$HOME/Telegram:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"

# You may need to manually set your language environment
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Aliases
alias ll="sl" # 'l' is enough
alias lt="ls -laht --color"
alias ls="ls -lahS --color"

alias python="python3"
alias arandr="wdisplays" # I use wayland btw
alias battery_percent="acpi -b | sed -r 's/[^,]*, ([0-9]+)%.*/\1/' | sort -rn | head -n 1"
alias cap='copy-abs-path'

# Conf development
alias reload='source ~/.zshrc'
# These use readlink to edit the file within the repo (fugitive recognizes it as a git repo)
alias zshconfig='$EDITOR $(readlink $HOME/.zshrc)'
alias swayconfig='$EDITOR $(readlink $HOME/.config/sway)/config'

# SSH agent magic
. $HOME/bin/start-agent.sh

# rtx is a pyenv and nvm + others wrapped into one
eval "$(rtx activate zsh)"

# Terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

# Haskell
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"

# bun completions
[ -s "/home/eeroh/.bun/_bun" ] && source "/home/eeroh/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

## Run .bashrc
[ -n ] && [ -f ~/.bashrc ] && . ~/.bashrc
