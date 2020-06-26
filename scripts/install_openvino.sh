#!/usr/bin/env bash

set -eux

readonly SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
pushd "$SCRIPT_DIR" > /dev/null

if ! ls l_mkl*.tgz; then
  axel "http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/16533/l_mkl_2020.1.217.tgz"
fi

tar xf l_mkl*.tgz
pushd l_mkl*/
sed -i 's/decline/accept/g' silent.cfg;
sudo ./install.sh --silent silent.cfg;
popd

if ! ls "l_openvino*.tgz" ]]; then
  axel "http://registrationcenter-download.intel.com/akdlm/irc_nas/16670/l_openvino_toolkit_p_2020.3.194.tgz"
fi

axel http://archive.ubuntu.com/ubuntu/pool/universe/f/fluidsynth/libfluidsynth1_1.1.11-4_amd64.deb

sudo apt install libgudev-1.0-dev

tar xf l_openvino_toolkit*.tgz
pushd l_openvino_toolkit*/
sudo ./install_openvino_dependencies.sh
sed -i 's/decline/accept/g' silent.cfg
sudo ./install.sh --silent silent.cfg
popd
