#!/bin/bash

# This is the main setup script that call other scripts to configure
# dotfiles, install general utils and pwn-related tools

red='\e[91m'
none='\e[0m'

# Sudo check
[[ $(id -u) != 0 ]] && 
if [ -z "$(groups $USERNAME | grep sudo)" ]; then
    echo -e "[+] Please make sure your current USER have ${red}sudo${none} access"
    exit 1
else
    echo "=============== Sudo Check Successful ==============="
fi

# Run scripts
echo "=============== Configuring dotfiles ==============="
chmod +x config.sh
./config.sh

echo "=============== Installing general utils ==============="
chmod +x utils.sh
./utils.sh

echo "=============== Installing pwn-related tools ==============="
chmod +x tools.sh
./tools.sh

echo "Things to do after installation: "
echo "run 'source ~/.bashrc' to update bash configuration"
echo "run ':PlugInstall' inside vim to install the plugins"
