#!/usr/bin/env bash

if command -v cargo &> /dev/null
then
    cargo install sccache

    RUSTC_WRAPPER=sccache cargo install \
        bat \
        bacon \
        bob-nvim \
        bottom \
        fd-find \
        just \
        nu \
        ripgrep \
        rtx-cli \
        tokei \
        zellij \
        zoxide
else
    echo "Please install rust from https://rustup.rs/"
    exit 1
fi
