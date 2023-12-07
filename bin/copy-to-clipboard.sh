#!/usr/bin/env bash

echo "called" > ~/config/test.output

if command -v wl-copy &> /dev/null
then
    # Linux on wayland
    wl-copy
elif command -v clip.exe &> /dev/null
then
    # Windows in wsl
    clip.exe
fi

