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
export PATH="$HOME/.pyenv/bin:$PATH"


# You may need to manually set your language environment
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Aliases
alias ll="sl"	# 'l' is enough
alias lt="ls -laht --color"
alias ls="ls -lahS --color"

alias v="vi"
alias vi="vim"
alias vim="nvim"

alias arandr="wdisplays"
alias reload='source ~/.zshrc'
alias zshconfig='$EDITOR $HOME/.zshrc'
alias swayconfig='$EDITOR $HOME/.config/sway/config'
alias battery_percent="acpi -b | sed -r 's/[^,]*, ([0-9]+)%.*/\1/' | sort -rn | head -n 1"
alias cargo='nocorrect cargo'
alias cap='copy-abs-path'

## Run .bashrc
[ -n ] && [ -f ~/.bashrc ] && . ~/.bashrc

. $HOME/bin/start-agent.sh

eval "$(direnv hook zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

[ -f "/home/hajhawa/.ghcup/env" ] && source "/home/hajhawa/.ghcup/env" # ghcup-env