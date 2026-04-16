#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${SCRIPT_DIR}/../dotfiles"
TARGET_DIR="${HOME}"

for src in "${DOTFILES_DIR}"/.*; do
    [[ "$(basename "${src}")" == "." ]] && continue
    [[ "$(basename "${src}")" == ".." ]] && continue

    dest="${TARGET_DIR}/$(basename "${src}")"

    if [[ -L ${dest} ]]; then
        echo "already a symlink, skipping: ${dest}"
        continue
    fi

    if [[ -e ${dest} ]]; then
        echo "backing up existing file: ${dest} -> ${dest}.bak"
        mv "${dest}" "${dest}.bak"
    fi

    ln -s "${src}" "${dest}"
    echo "linked: ${dest} -> ${src}"
done
