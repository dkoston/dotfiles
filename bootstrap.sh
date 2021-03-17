#!/bin/bash

# Bootstrap symlinks dotfiles to this repo so this repo can remain
# the source of truth 

if [[ "$SHELL" == "/bin/zsh" ]]; then
  echo "Installing ZSH custom files for oh my zsh"
  ln -s "$(pwd)/common/aliases" "${HOME}/.oh-my-zsh/custom/aliases.zsh"
  ln -s "$(pwd)/common/environment" "${HOME}/.oh-my-zsh/custom/environment.zsh"
  ln -s "$(pwd)/common/functions.zsh" "${HOME}/.oh-my-zsh/custom/functions.zsh"
  ln -s "$(pwd)/zsh/autocomplete.zsh" "${HOME}/.oh-my-zsh/custom/autocomplete.zsh"
elif [[ "$SHELL" == "/bin/bash" ]]; then
  echo "Installing BASH profile"
  ln -s "$(pwd)/bash/profile" "${HOME}/.bash_profile"
else
  echo "Unsupported shell: $SHELL. Only .gitignore will be installed"
fi

echo "Installing user level gitignore"
ln -s "$(pwd)/git/gitignore" "${HOME}/.gitignore"
git config --global core.excludesfile "${HOME}/.gitignore"

echo "Setting up go for private github repos"
git config --global url.git@github.com:.insteadOf https://github.com/
