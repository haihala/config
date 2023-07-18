# Config

Dungeons, dragons, dotfiles and dives

A bunch of simple scripts and dotfiles I use. Should eventually be able to recreate my preferred linux environment really quicly.

## Setup

1. Run a new-ish fedora workstation
2. `sudo dnf_install.sh`
3. Install the following (not found in dnf by default)
   1. VScode - [link](https://code.visualstudio.com/docs/setup/linux)
   2. swaylock-effects - [link](https://github.com/mortie/swaylock-effects)
      1. Compile by hand to avoid a bug on the lock screen
   3. mpv - [link](https://forums.fedoraforum.org/showthread.php?324163-install-mpv-player-on-fedora32&p=1835826#post1835826)
   4. oh-my-zsh - [link](https://ohmyz.sh/)
   5. z - [link](https://github.com/agkozak/zsh-z)
   6. zsh-autosuggestions - [link](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)
   7. obsidian - [link](https://obsidian.md/download)
4. Run `./link.sh` from the repository root
5. Check git email with `git config user.email`
6. Edit crontab to run `bin/cron_battery.sh` (for laptops)
7. Handle ssh keys (See [instructions](#setting-up-ssh-key-magic))
8. Install pyenv

## What goes where

- `dotfiles/*` is linked to `$HOME/*`
- `home_config/*` -> `$HOME/.config/*`
- `bin` -> `$HOME/bin`
- `non_linked` isn't linked anywhere, but I still think I should have handy.

## Setting up SSH key magic

Requirements:

- Python3
- pip-package pexpect
- gpg

1. Generate an ssh key with a passphrase
2. Generate a gpg key with `gpg --generate-full-key`
3. Put `<path to ssh key> <ssh key passphrase>` in a file
4. Encrypt previous file with `gpg --output ~/.ssh/key_password_vault.asc --encrypt --recipient <email> <path of file from previous step>`
5. Remove `~/.sshagentenv` if it exists
6. `reload`
7. **Remove the file you temporarily had your password in written in plain text**
