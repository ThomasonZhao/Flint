#!/bin/bash

# This is the general utils setup script 

############### Install utils through apt ###############

# Change apt source list
read -p "Do you want to change your apt source list to aliyun mirrors? (Y/N)" -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Backing up and creating a new one..."
    mv /etc/apt/sources.list /etc/apt/sources.list.bak
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse"                 >> /etc/apt/sources.list
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse"             >> /etc/apt/sources.list
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse"        >> /etc/apt/sources.list
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse"    >> /etc/apt/sources.list
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse"         >> /etc/apt/sources.list
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse"     >> /etc/apt/sources.list
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse"        >> /etc/apt/sources.list
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse"    >> /etc/apt/sources.list
    echo "deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse"       >> /etc/apt/sources.list
    echo "deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse"   >> /etc/apt/sources.list
fi

apt update
apt upgrade -y

# Enable 32 bit support
dpkg --add-architecture i386

# Environment for PWN and C/C++ development
apt install -y \
    autoconf \
    bc \
    bison \
    build-essential \
    clang \
    cmake \
    cpio \
    curl \
    default-jdk \
    flex \
    g++-multilib \
    gcc-multilib \
    git \
    libc6-i386 \
    libc6-dev-i386 \
    libedit-dev \
    libelf-dev \
    libffi-dev \
    libglib2.0-dev \
    libgmp-dev \
    libini-config-dev \
    libpcap-dev \
    libpixman-1-dev \
    libseccomp-dev \
    libssl-dev \
    libtool-bin \
    llvm \
    man-db \
    manpages-dev \
    nasm \
    python-is-python3 \
    python3-dev \
    python3-pip \
    rubygems \
    squashfs-tools \
    unzip \
    upx-ucl \
    wget \
    --fix-missing

# Basic utils
apt install -y \
    arping \
    binutils \
    binwalk \
    bsdmainutils \
    bsdutils \
    debianutils \
    diffutils \
    ed \
    elfutils \
    emacs \
    ethtool \
    exiftool \
    expect \
    findutils \
    gdb \
    gdb-multiarch \
    genisoimage \
    gnupg-utils \
    hexedit \
    iproute2 \
    iputils-ping \
    ipython3 \
    keyutils \
    kmod \
    ltrace \
    nano \
    net-tools \
    netcat \
    nmap \
    openssh-server \
    parallel \
    patchelf \
    pcaputils \
    pcre2-utils \
    psutils \
    rsync \
    ruby \
    ruby-dev \
    screen \
    silversearcher-ag \
    socat \
    strace \
    sudo \
    tmux \
    tree \
    vim \
    whiptail \
    zsh \
    --fix-missing

############### Install utils through pip ###############

# Change pip source list
read -p "Do you want to change your pip source list to aliyun mirrors? (Y/N)" -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    if [ -f ~/.pip/pip.conf ]; then
        echo "You already have pip source list, backing up and creating a new one..."
        mv ~/.pip/pip.conf ~/.pip/pip.conf.bak
    else
        mkdir ~/.pip
    fi

    echo "[global]" > ~/.pip/pip.conf
    echo "index-url = https://mirrors.aliyun.com/pypi/simple/" >> ~/.pip/pip.conf
    echo "[install]" >> ~/.pip/pip.conf
    echo "trusted-host=mirrors.aliyun.com" >> ~/.pip/pip.conf
fi

pip install virtualenvwrapper

############### Other utils setup ###############

# Install plugin for Vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
