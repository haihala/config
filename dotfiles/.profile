if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    # Only do this on the laptop where X exists and starts
    sudo NetworkManager
    # Enable ssh agent
    eval `ssh-agent`
    ssh-add ~/.ssh/id_rsa
    exec startx
fi

. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
