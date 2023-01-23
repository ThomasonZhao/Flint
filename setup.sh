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
