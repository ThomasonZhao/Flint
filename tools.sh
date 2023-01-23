#!/bin/bash

# This is the pwn-related tools setup script

############### Tools from pip ###############

# New python virtualenv for pwn
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Devel
source /usr/local/bin/virtualenvwrapper.sh
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

ln -sf /usr/bin/ipython3 /usr/bin/ipython

############### Tools download from web ###############

# pwn-gdb plugins
git clone https://github.com/hugsy/gef /opt/gef
git clone --recurse-submodules https://github.com/pwndbg/pwndbg /opt/pwndbg
git clone https://github.com/jerdna-regeiz/splitmind /opt/splitmind

# # qemu
# apt install -y ninja-build pkg-config zlib1g-dev libglib2.0-dev libpixman-1-dev libfdt-dev 
# git clone https://gitlab.com/qemu-project/qemu.git /opt/qemu
# cd /opt/qemu
# git submodule init
# git submodule update --recursive
# ./configure
# make -j $(nproc)
# make install
# 
# # aflplusplus
# git clone https://github.com/aflplusplus/aflplusplus /opt/aflplusplus
# cd /opt/aflplusplus
# make distrib
# make install
# 
# # capstone
# git clone https://github.com/aquynh/capstone /opt/capstone
# cd /opt/capstone
# ./make.sh
# ./make.sh install
# 
# # main_arena
# wget https://raw.githubusercontent.com/bash-c/main_arena_offset/master/main_arena -O /usr/bin/main_arena
# chmod +x /usr/bin/main_arena
# 
# # one_gadget
# gem install one_gadget
# 
# # radare2
# git clone https://github.com/radareorg/radare2 /opt/radare2
# cd /opt/radare2
# sys/install.sh
# 
# # rappel
# git clone https://github.com/yrp604/rappel /opt/rappel
# cd /opt/rappel
# make
# cp bin/rappel /usr/bin/rappel
# 
# # rp++
# wget https://github.com/0vercl0k/rp/releases/download/v2.0.2/rp-lin-x64 -O /usr/bin/rp++
# chmod +x /usr/bin/rp++
# 
# # seccomp-tools
# gem install seccomp-tools
# 
# # tcpdump
# git clone https://github.com/the-tcpdump-group/tcpdump /opt/tcpdump
# cd /opt/tcpdump
# ./configure
# make install
# 