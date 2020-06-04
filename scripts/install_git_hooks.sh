#!/usr/bin/env bash

set -eu

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

pushd "$SCRIPT_DIR" > /dev/null

readonly CLANG_FORMAT="$(which clang-format)"

if [[ ! -x "$CLANG_FORMAT" ]]; then
    printf "clang-format is not found:\n"
    printf "\t$ sudo apt-get install clang-format\n"
    exit 1
fi

readonly GIT_DIR="../.git/hooks/"

cp "pre-commit" "$GIT_DIR"

popd >> /dev/null

printf "Hooks installed\n"
