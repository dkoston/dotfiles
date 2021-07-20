#Include Extras
EXTRAS=~/dotfiles/zsh/extras
if [ -f "$EXTRAS" ]; then
    source $EXTRAS
else
    echo "No extras file found at ${EXTRAS}"
fi

#auto completion for git aliases
compdef _gp gp

# Add tab completion for navigating dotfiles functions
compdef _cddf df
