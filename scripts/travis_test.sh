#!/usr/bin/env bash

set -eux

pushd "$(dirname "$(readlink -f "$0")")" > /dev/null

printenv

if [[ $CXX == "g++" ]]; then
  conan profile new default --detect
  conan profile update settings.compiler.libcxx=libstdc++11 default
fi

pushd .. > /dev/null

mkdir build && cd build
conan install ..
cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release
cmake --build . -- -j2
ctest -j2
