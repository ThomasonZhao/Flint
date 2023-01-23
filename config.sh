#!/bin/bash

# This is the config setup script 

############### Link all config file ###############

cd config/
for file in *
do
    ln -sf $PWD/$file ~/."$file"
done