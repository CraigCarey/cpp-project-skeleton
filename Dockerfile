FROM ubuntu:18.04

RUN set -eu; \
    apt-get update && apt-get install -y --no-install-recommends \
    axel \
    cpio \
    sudo \
    gdbserver \
    lsb-release \
    openssh-server \
    build-essential \
    git \
    cmake \
    nano \
    python3-pip \
    libssl-dev;

# Enable remote debugging
RUN set -eu; \
    mkdir /var/run/sshd; \
    echo 'root:root' | chpasswd; \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config; \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd;

# 22 for ssh server, 7777 for gdb server
EXPOSE 22 7777

ARG TZ="Europe/Belfast"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG CMAKE_VERSION="3.17.3"
RUN set -eux; \
    axel "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz"; \
    tar xf "cmake-${CMAKE_VERSION}.tar.gz"; \
    cd "cmake-${CMAKE_VERSION}"; \
    cmake .; \
    make -j $(nproc) install; \
    apt-get purge cmake -y;

RUN set -eux; \
    $(which python3); \
    ln -sf $(which python3) /usr/bin/python; \
    ln -sf $(which pip3) /usr/bin/pip;

RUN apt-get install -y python3-setuptools

RUN pip install --upgrade pip && pip install --no-cache-dir conan

CMD bash
