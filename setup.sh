#!/bin/bash

# This is the main setup script that call other scripts to configure
# dotfiles, install general utils and pwn-related tools

red='\e[91m'
none='\e[0m'

# Root check
[[ $(id -u) != 0 ]] && echo -e "[+] Please run this script as ${red}root${none}" && exit 1

echo "=============== Configuring dotfiles ==============="
chmod +x config.sh
./config.sh

echo "=============== Installing general utils ==============="
chmod +x utils.sh
./utils.sh

echo "=============== Installing pwn-related tools ==============="
chmod +x tools.sh
./tools.sh

echo "Things after installation: "
echo "run 'source ~/.bashrc' to update bash configuration"
echo "run ':PlugInstall' inside vim to install the plugins"

# # arm&mips运行库
# sudo apt-get install -y \
#     libc6-arm64-cross \
#     libc6-armel-cross \
#     libc6-armhf-cross \
#     libc6-mips-cross \
#     libc6-mips32-mips64-cross \
#     libc6-mips32-mips64el-cross \
#     libc6-mips64-cross \
#     libc6-mips64-mips-cross \
#     libc6-mips64-mipsel-cross \
#     libc6-mips64el-cross \
#     libc6-mipsel-cross \
#     libc6-mipsn32-mips-cross \
#     libc6-mipsn32-mips64-cross \
#     libc6-mipsn32-mips64el-cross \
#     libc6-mipsn32-mipsel-cross

# # binutils
# sudo apt-get install -y \
#     binutils-mips-linux-gnu-dbg/bionic-security \
#     binutils-mipsel-linux-gnu-dbg/bionic-security \
#     binutils-mips64-linux-gnuabi64-dbg/bionic-security \
#     binutils-mips64el-linux-gnuabi64-dbg/bionic-security \
#     binutils-arm-linux-gnueabi-dbg/bionic-security