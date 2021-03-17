#auto completion for git functions
__git_complete _g __git_main
__git_complete _gch _git_checkout
__git_complete _gp _git_pull

#aliases for autocompletions
alias gp="_gp"
alias gch="_gch"

# Add tab completion for navigating dotfiles functions
complete -F _cddf df

# Add tab completion for container names to docker functions
complete -o "default" -o "nospace" -W "$(docker ps --format \"{{.Names}}\")" docker docker_enter docker_enter_id docker_id docker_rm;
complete -o "default" -o "nospace" -W "$(docker images --format \"{{.ID}}\")" docker_rm_image;