#!/usr/bin/env bash

obsidian_path="$(dirname "$(realpath $0)")/bin/git-ignored/obsidian"
# I want this to not pick up on the ...-arm64.AppImage
curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
    | jq '.assets[] | select(.name | test("\\d+\\.\\d+\\.AppImage$")) | .browser_download_url' -r \
    | wget -qi - -O $obsidian_path
chmod +x $obsidian_path

# They have an official download page, but it's not easy to hook up to bash scripts
# So get the one off of reddit
wget -qi https://styles.redditmedia.com/t5_2mz3dr/styles/communityIcon_l538j35ftd3b1.png -O ~/Pictures/obsidian-icon.png
