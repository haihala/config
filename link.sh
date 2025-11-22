#!/usr/bin/env bash
set -e

# Safeguards
if [[ "$0" != "./link.sh" ]]; then
    echo "Please invoke from repo root with './link.sh'"
    exit 1
fi

echo "Hello, thanks for using the automated config linker."

# Make sure all scripts are executable
chmod +x bin/*

# All dotfiles and folders
for dot in $(ls -AL dotfiles/); do
    ln -fs $(pwd)/dotfiles/$dot $HOME
    echo "linked $dot to $HOME/$dot"
done

if [[ ! -L $HOME/bin && -d $HOME/bin ]]; then
    echo -e "\e[33m$HOME/bin exists, please delete and rerun script to link\e[0m"
else
    ln -fs $(pwd)/bin $HOME
    echo "linked bin to $HOME/bin"
fi

# ~/.config stuff
for conf in $(ls -AL home_config/); do
    ln -fs $(pwd)/home_config/$conf $HOME/.config/
    echo "linked $conf to $HOME/.config/$conf"
done

# Desktop icons
for desk in $(ls -AL desktop/); do
    ln -fs $(pwd)/desktop/$desk $HOME/.local/share/applications
    echo "linked $desk to $HOME/.local/share/applications/$desk"
done

