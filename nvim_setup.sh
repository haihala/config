#!/usr/bin/env bash

# Check that installers are installed.
if ! command -v mise 2>&1 >/dev/null
then
    echo "Mise is not installed"
    exit 1
fi

mise use -g python
mise use -g lua-language-server
mise use -g node

# Note to self, some of these maybe ought to be installed within the project
npm install -g typescript typescript-language-server
npm install -g @tailwindcss/language-server
npm install -g vscode-langservers-extracted # HTML, CSS, JSON, eslint, maybe markdown later
npm install -g svelte-language-server

rustup component add rust-analyzer
cargo install --git https://github.com/wgsl-analyzer/wgsl-analyzer.git wgsl-analyzer

pip install python-lsp-server

echo "Installing marksman"
marksman_path="$(dirname "$(realpath $0)")/bin/git-ignored/marksman"
# Marksman allows for brew, nix, snap or prebuilt binaries, this is the least pain
# NOTE: This assumes that the user running this script can write to /usr/local/bin
curl -s https://api.github.com/repos/artempyanykh/marksman/releases/latest \
    | jq '.assets[] | select(.name=="marksman-linux-x64") | .browser_download_url' -r \
    | wget -qi - -O $marksman_path
chmod +x $marksman_path
echo "Marksman installed"
