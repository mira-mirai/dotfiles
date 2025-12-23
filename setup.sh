#!/bin/bash

# setup script for new computers/accounts

# get dir for dotfiles repo and change to it
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" ))" &> /dev/null && pwd)
ln -s $SCRIPT_DIR/.bashrc ~/.bashrc
ln -s $SCRIPT_DIR/.bash_profile ~/.bash_profile
ln -s $SCRIPT_DIR/.aliases ~/.aliases
