# Config

Dungeons, dragons, dotfiles and dives

A bunch of simple scripts and dotfiles I use. Should eventually be able to recreate my preferred linux environment really quicly.

## Setup

1. Run a new-ish fedora workstation
2. `sudo dnf_install.sh`
3. Run `./link.sh` from the repository root
   1. You may have to create the `.config` folder in home.
4. Install rust stuff
    1. Install [Rustup](https://rustup.rs/)
    2. Run `./cargo_install.sh`
    3. Install `python` and `node` with `mise`
    4. Install `nvim` with `bob install stable` / `bob use stable`
        1. Install [Packer](https://github.com/wbthomason/packer.nvim)
        2. Do several cycles of restart and PackerUpdate
5. Install the following (not found in dnf by default)
   1. swaylock-effects - [link](https://github.com/mortie/swaylock-effects)
      1. Compile by hand to avoid a bug on the lock screen
   2. obsidian - [link](https://obsidian.md/download)
6. Check git email with `git config user.email`
7. Edit crontab to run `bin/cron_battery.sh` (for laptops)
8. Handle ssh keys (See [instructions](#setting-up-ssh-key-magic))
9. Setup Tmux
    1. Install [tpm](https://github.com/tmux-plugins/tpm)
    2. Open fish (should open tmux as well)
    3. `tmux source ~/.config/tmux/tmux.conf`
    4. Install tpm packages with prefix+I

## What goes where

- `dotfiles/*` is linked to `$HOME/*`
- `home_config/*` -> `$HOME/.config/*`
- `bin` -> `$HOME/bin`

## Setting up SSH key magic

Requirements:

- Python3
- pip-package pexpect
- gpg

1. Generate an ssh key with a passphrase
2. Generate a gpg key with `gpg --generate-key`
3. Put `<path to ssh key> <ssh key passphrase>` in a file
4. Encrypt previous file with `gpg --output ~/.ssh/key_password_vault.asc --encrypt --recipient <email> <path of file from previous step>`
5. Remove `~/.sshagentenv` if it exists
6. `reload`
7. **Remove the file you temporarily had your password in written in plain text**
