#!/usr/bin/env bash

if command -v cargo &>/dev/null; then
    cargo install sccache

    RUSTC_WRAPPER=sccache cargo install \
        bat \
        bacon \
        bob-nvim \
        bottom \
        cargo-make \
        fd-find \
        just \
        mise \
        nu \
        ripgrep \
        tokei \
        zoxide
else
    echo "Please install rust from https://rustup.rs/"
    exit 1
fi
