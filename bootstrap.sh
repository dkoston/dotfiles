#!/bin/bash

# Bootstrap symlinks dotfiles to this repo so this repo can remain
# the source of truth 

ln -s $(pwd)/bash/profile ${HOME}/.bash_profile
ln -s $(pwd)/git/gitignore ${HOME}/.gitignore
