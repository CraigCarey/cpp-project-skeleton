#!/usr/bin/env bash

set -eux

function mkcd()
{
  rm -rf "$1" && mkdir "$1" && pushd "$1"
}

# Make the script agnostic to where it's called from
pushd "$(dirname "$(readlink -f "$0")")" > /dev/null

# Build libskeleton release and debug against Conan packages and install to /usr/local/
pushd libskeleton
mkcd build

conan install .. --build=missing

cmake .. -DUSE_CONAN_PACKAGE=True -DCMAKE_BUILD_TYPE=Debug
cmake --build .
ctest
sudo cmake --install .

cmake .. -DUSE_CONAN_PACKAGE=True -DCMAKE_BUILD_TYPE=Release
cmake --build .
ctest
sudo cmake --install .

popd

# Build without Conan packages (just to prove it works, doesn't install)
mkcd build2

cmake ..
cmake --build .
ctest

popd
popd

# Remove Conan packages and install using apt instead
conan remove -f poco
conan remove -f boost
conan remove -f gtest

sudo apt install libpoco-dev libboost-all-dev libgtest-dev

# Build consumer against libskeleton and apt installed dependencies
pushd consumer
mkcd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build .
./skeletonconsumer
