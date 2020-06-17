#!/usr/bin/env bash

set -eux

function mkcd()
{
  rm -rf "$1" && mkdir "$1" && pushd "$1"
}

function revert_conan_uninstall()
{
  # revert simulated uninstall (if present)
  if [[ -d ~/.conan/data.bk ]]; then
    mv ~/.conan/data.bk ~/.conan/data
  fi
}

# Make the script agnostic to where its called from
pushd "$(dirname "$(readlink -f "$0")")" > /dev/null

# Remove any apt install packages that may confuse things
sudo apt remove -y libpoco-dev libboost-all-dev libgtest-dev
sudo apt autoremove -y

# Remove old install
sudo rm -rf /usr/local/include/skeleton/ /usr/local/lib/libskeleton.a /usr/local/lib/cmake/Skeleton/

revert_conan_uninstall

# Build libskeleton release and debug against Conan packages and install to /usr/local/
pushd libskeleton
mkcd build

conan install .. --build=missing -r=artifactory # conan remote list

cmake .. -DUSE_CONAN_PACKAGE=True -DCMAKE_BUILD_TYPE=Debug
cmake --build . --parallel 2
ctest
cpack
sudo cmake --install .

cmake .. -DUSE_CONAN_PACKAGE=True -DCMAKE_BUILD_TYPE=Release
cmake --build . --parallel 2
ctest
cpack
sudo cmake --install .

popd

## Build without Conan packages (just to prove it works, doesn't install)
#mv ~/.conan/data ~/.conan/data.bk # simulate uninstall to save time
##conan remove -f poco
##conan remove -f boost
##conan remove -f gtest
#sudo apt install -y libpoco-dev libboost-all-dev libgtest-dev
#mkcd build2
#
#cmake ..
#cmake --build .
#ctest
#
#revert_conan_uninstall
#
#popd

popd

# Build consumer against libskeleton and Conan installed dependencies
# TODO: build Conan linked libskeleton against apt installed dependencies
pushd consumer
mkcd build
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build .
./skeletonconsumer
