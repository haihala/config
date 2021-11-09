export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="random"

HYPHEN_INSENSITIVE="true"
DISABLE_AUTO_UPDATE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="%c"

plugins=(autojump autopep8 cabal cake capistrano catimg chucknorris coffee django docker encode64 extract gem git gitfast git-extras git-flow github jira jsontools meteor ng node npm perl perms pip python rand-quote repo ruby scala sudo systemd vscode wd z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export MANPATH="/usr/local/man:$MANPATH"

# Path updates
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/home/eeroh/.cache/activestate/bin:$PATH"

# You may need to manually set your language environment
export LANG=en_GB.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Aliases
alias ll="sl"	# 'l' is enough

alias v="vi"
alias vi="vim"
alias vim="nvim"

alias python="python3"
alias arandr="wdisplays"
alias reload='source ~/.zshrc'
alias zshconfig='$EDITOR $HOME/.zshrc'
alias swayconfig='$EDITOR $HOME/.config/sway/config'
alias battery_percent="acpi -b | head -n 1 | grep -P -o '[0-9]+(?=%)'"
alias cargo='nocorrect cargo'
alias cap='copy-abs-path'

## Run .bashrc
[ -n ] && [ -f ~/.bashrc ] && . ~/.bashrc

. $HOME/bin/start-agent.sh

eval "$(direnv hook zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/eeroh/gsutil/google-cloud-sdk/path.zsh.inc' ]; then . '/home/eeroh/gsutil/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/eeroh/gsutil/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/eeroh/gsutil/google-cloud-sdk/completion.zsh.inc'; fi
