#!/bin/bash

# This is the pwn-related tools setup script

############### Tools from pip ###############

# New python virtualenv for pwn
export PATH=~/.local/bin:$PATH
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source ~/.local/bin/virtualenvwrapper.sh
mkvirtualenv pwn
workon pwn
pip install --force-reinstall \
    angr \
    asteval \
    capstone \
    flask \
    git+https://github.com/Gallopsled/pwntools#egg=pwntools \
    git+https://github.com/secdev/scapy#egg=scapy \
    jupyter \
    keystone-engine \
    LibcSearcher \
    psutil \
    pycryptodome \
    r2pipe \
    requests \
    ropper \
    selenium \
    tabulate \
    typing-extensions \
    unicorn \

sudo ln -sf /usr/bin/ipython3 /usr/bin/ipython

############### Tools download from web ###############

# pwn-gdb plugins
sudo git clone https://github.com/hugsy/gef /opt/gef
sudo git clone --recurse-submodules https://github.com/pwndbg/pwndbg /opt/pwndbg
sudo git clone https://github.com/jerdna-regeiz/splitmind /opt/splitmind

# qemu
sudo apt install -y ninja-build pkg-config zlib1g-dev libglib2.0-dev libpixman-1-dev libfdt-dev 
sudo git clone https://gitlab.com/qemu-project/qemu.git /opt/qemu
cd /opt/qemu
sudo git submodule init
sudo git submodule update --recursive
sudo ./configure
sudo make -j $(nproc)
sudo make install

# aflplusplus
sudo git clone https://github.com/aflplusplus/aflplusplus /opt/aflplusplus
cd /opt/aflplusplus
sudo make distrib
sudo make install

# capstone
sudo git clone https://github.com/aquynh/capstone /opt/capstone
cd /opt/capstone
sudo ./make.sh
sudo ./make.sh install

# main_arena
sudo wget https://raw.githubusercontent.com/bash-c/main_arena_offset/master/main_arena -O /usr/bin/main_arena
sudo chmod +x /usr/bin/main_arena

# one_gadget
sudo gem install one_gadget

# radare2
sudo git clone https://github.com/radareorg/radare2 /opt/radare2
cd /opt/radare2
sudo sys/install.sh

# rappel
sudo git clone https://github.com/yrp604/rappel /opt/rappel
cd /opt/rappel
sudo make
sudo cp bin/rappel /usr/bin/rappel

# rp++
sudo wget https://github.com/0vercl0k/rp/releases/download/v2.0.2/rp-lin-x64 -O /usr/bin/rp++
sudo chmod +x /usr/bin/rp++

# seccomp-tools
sudo gem install seccomp-tools

# tcpdump
sudo git clone https://github.com/the-tcpdump-group/tcpdump /opt/tcpdump
cd /opt/tcpdump
sudo ./configure
sudo make install

############### More libraries for other architecture ###############

# arm & mips libraries
sudo apt install -y \
    libc6-arm64-cross \
    libc6-armel-cross \
    libc6-armhf-cross \
    libc6-mips-cross \
    libc6-mips32-mips64-cross \
    libc6-mips32-mips64el-cross \
    libc6-mips64-cross \
    libc6-mips64-mips-cross \
    libc6-mips64-mipsel-cross \
    libc6-mips64el-cross \
    libc6-mipsel-cross \
    libc6-mipsn32-mips-cross \
    libc6-mipsn32-mips64-cross \
    libc6-mipsn32-mips64el-cross \
    libc6-mipsn32-mipsel-cross

# binutils
sudo apt install -y \
    binutils-mips-linux-gnu-dbg/bionic-security \
    binutils-mipsel-linux-gnu-dbg/bionic-security \
    binutils-mips64-linux-gnuabi64-dbg/bionic-security \
    binutils-mips64el-linux-gnuabi64-dbg/bionic-security \
    binutils-arm-linux-gnueabi-dbg/bionic-security
