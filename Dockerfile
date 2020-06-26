FROM ubuntu:18.04

RUN set -eu; \
    apt-get update && apt-get install -y --no-install-recommends \
    axel \
    cpio \
    sudo \
    gdbserver \
    lsb-release \
    libgtk-3-dev \
    openssh-server; \
    rm -rf /var/lib/apt/lists/*

# Enable remote debugging
RUN set -eu; \
    mkdir /var/run/sshd; \
    echo 'root:root' | chpasswd; \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd;

# 22 for ssh server, 7777 for gdb server
EXPOSE 22 7777

ARG DOWNLOAD_LINK_MKL=http://registrationcenter-download.intel.com/akdlm/irc_nas/tec/16533/l_mkl_2020.1.217.tgz
ARG INSTALL_DIR_MKL=/opt/intel/mkl
ARG TMP_DIR_MKL=/tmp/mkl_installer

RUN set -eu; \
    mkdir -p $TMP_DIR_MKL && cd $TMP_DIR_MKL; \
    axel -c $DOWNLOAD_LINK_MKL; \
    tar xf l_mkl*.tgz; \
    cd l_mkl*/; \
    sed -i 's/decline/accept/g' silent.cfg; \
    ./install.sh --silent silent.cfg;

ARG DOWNLOAD_LINK_OV=http://registrationcenter-download.intel.com/akdlm/irc_nas/16670/l_openvino_toolkit_p_2020.3.194.tgz
ARG INSTALL_DIR_OV=/opt/intel/openvino
ARG TMP_DIR_OV=/tmp/openvino_installer

RUN set -eu; \
    mkdir -p $TMP_DIR_OV && cd $TMP_DIR_OV; \
    axel -c $DOWNLOAD_LINK_OV; \
    tar xf l_openvino_toolkit*.tgz; \
    cd l_openvino_toolkit*; \
    sed -i 's/decline/accept/g' silent.cfg; \
    ./install.sh -s silent.cfg; \
    rm -rf $TMP_DIR_OV

RUN set -eu; \
    ${INSTALL_DIR_OV}/install_dependencies/install_openvino_dependencies.sh

RUN apt-get update && apt-get install python3-pip -y && \
    pip3 install pyyaml requests && \
    cd ${INSTALL_DIR_OV}/deployment_tools/tools/model_downloader && \
    python3 downloader.py --name alexnet

RUN set -eu; \
    /opt/intel/openvino/deployment_tools/demo/demo_squeezenet_download_convert_run.sh;

RUN set -eu; \
    apt-get install -y --no-install-recommends \
    build-essential \
    git \
    cmake \
    nano \
    python3-pip;

RUN set -eu; \
    ln -sf $(which python3) $(which python); \
    ln -sf $(which pip3) /usr/bin/pip; \
    python --version; \
    pip --version;

COPY libskeleton/conan/conanfile.txt /root/

CMD bash
