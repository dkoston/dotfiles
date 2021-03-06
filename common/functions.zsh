#Fast change to a sub-folder of dotfiles. Alias this to 'df' via autocomplete.sh
function _cddf() {
    local cur opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$(cd ~/dotfiles || exit; ls -d * | sed 's|/./||')
    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}


# source these dotfiles (bash or zsh)
function sdf() {
  SHELL=$0
  if [[ "$SHELL" == "/bin/bash" ]]; then
    source ~/.bash_profile
  elif [[ "$SHELL" == "/bin/zsh" ]]; then
    source ~/.zprofile
  else
    echo "Shell ${SHELL} unsupported"
  fi
}


# Git
#git rebase HEAD~${n}
function grih(){
  git rebase -i HEAD~"$1"
}

# Get current git branch
function gb(){
  git branch | grep -v master | grep -v main | grep "\*" | awk '{print $2}'
}

# git pull -r $this_branch (allows master)
function gp(){
  git pull -r origin "$(gb)"
}

#git push origin $this_branch (does not allow master)
function gpo(){
  git push origin "$(gb)"
}

#git push --force origin $this_branch (does not allow master or main)
function gfpo(){
   git push --force origin "$(gb)"
}

#git rebase origin main
function grom() {
  git rebase origin main
}

#git rebase origin $this_branch
function gro() {
  git rebase origin/"$(gb)"
}

#grab our changes from origin, add them, and continue rebase
function grco() {
  git status | grep both | awk '{print $3}' | xargs git checkout --ours
  git status | grep both | awk '{print $3}' | xargs git add
  git rebase --continue
}

#grab their changes from origin, add them, and continue rebase
function grct() {
  git status | grep both | awk '{print $3}' | xargs git checkout --theirs
  git status | grep both | awk '{print $3}' | xargs git add
  git rebase --continue
}



# DOCKER
# get all containers and IPs
function dips() {
    docker ps -q | xargs -n 1 docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}} {{ .Name }}' | sed 's/ \// /'
}

# restart all containers with docker_ name prefix
function dcra() {
 docker ps -a | grep docker_ | awk '{print $1}' | xargs docker restart
}

# Get a container's id by name match
function docker_id(){
    if [[ "$1" == "" ]]; then
	    echo "you need to specify a string to match the container name against"
	    echo "Usage: docker_id <match>"
	    echo "--------------------------------"
	    echo "available containers:"
	    docker ps
    else
	    docker ps | grep "$1" | sed 's/|/ /' | awk '{print $1}'
    fi
}


#Enter a docker container
function docker_enter_id(){
    if [[ "$1" == "" ]]; then
	echo "you need to specify a container id"
	echo "Usage: docker_enter_id <container_id>"
	echo "--------------------------------"
	echo "available containers:"
	docker ps
    else
        docker exec -it "$1" bash
    fi
}

#Enter a docker container by name or ID match (bash)
function docker_enter(){
    if [[ "$1" == "" ]]; then
	    echo "you need to specify a string to match the container name against"
	    echo "Usage: docker_enter <match>"
	    echo "--------------------------------"
	    echo "available containers:"
	    docker ps
    else
	    DOCKERID=$(docker ps | grep "$1" | sed 's/|/ /' | awk '{print $1}' 2>&1)
      docker exec -it "$DOCKERID" bash
    fi
}

#Enter a docker container by name or ID match (ash)
function docker_enter_alpine(){
    if [[ "$1" == "" ]]; then
	    echo "you need to specify a string to match the container name against"
	    echo "Usage: docker_enter <match>"
	    echo "--------------------------------"
	    echo "available containers:"
	    docker ps
    else
	    DOCKERID=$(docker ps | grep "$1" | sed 's/|/ /' | awk '{print $1}' 2>&1)
      docker exec -it "$DOCKERID" ash
    fi
}

# Delete docker container by name
function docker_rm(){
  if [[ "$1" == "" ]]; then
    echo "you need to specify a string to match the container name against"
    echo "Usage: docker_rm <match>"
    echo "--------------------------------"
    echo "available containers:"
    docker ps
  else
    DOCKERID=$(docker ps | grep "$1" | sed 's/|/ /' | awk '{print $1}' 2>&1)
    docker rm -f "$DOCKERID"
  fi
}


#Tail container logs by partial string match of name
function docker_logs(){
  if [[ "$1" == "" ]]; then
    echo "you need to specify a string to match the container name against"
    echo "Usage: docker_logs <match>"
    echo "--------------------------------"
    echo "available containers:"
    docker ps
  else
   DOCKERID=$(docker ps | grep "$1" | awk '{print $1}' | head -n 1 2>&1)
   docker logs --tail 50 -f "$DOCKERID"
  fi
}



# clean up unused images
function docker_remove_images(){
  for i in $(docker images | grep "<none>" | awk '{print $3}'); do
      docker rmi ${i}
  done
  echo "All unused images removed"
}

# remove all docker images
function docker_remove_all_images(){
  docker rmi "$(docker images -q)"
}

# remove all docker containers
function docker_remove_all_containers(){
  docker rm -f "$(docker ps -a -q)"
}

# remove all stopped docker containers
function docker_remove_stopped(){
  for i in $(docker ps -a --filter "status=exited" --format "{{.ID}}"); do
    docker rm "${i}"
  done
  echo "All stopped containers removed"
}

# Delete all old unused containers and images
function docker_garbage_collect(){
  docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc
}

#Remove all custom docker networks
function docker_remove_networks(){
  for i in $(docker network ls -f type=custom | grep -v NAME | awk '{print $1}'); do
    docker network rm "${i}"
  done
}

# k8s
function kc-deployments-ns(){
  kubectl get deployments --namespace="$1"
}

function kc-events-ns(){
  kubectl get events --namespace="$1"
}

function kc-pods-ns(){
  kubectl get pods --namespace="$1"
}

function kc-logs-ns(){
  kubectl logs -f --namespace="$1" "$2"
}

function kc-enter-ns(){
  COMMAND=/bin/ash
  if [[ "$3" != "" ]]; then
    COMMAND=$3
  fi

  kubectl exec --namespace="$1" -it "$2" env COLUMNS=200 LINES=300 TERM=xterm ${COMMAND}
}

function keb() {
  kc-enter-ns default $1 bash
}



function kc-describe-pod-ns(){
  kubectl describe pod --namespace="$1" "$2"
}

function kc-delete-pod-ns(){
  kubectl delete pod --namespace="$1" "$2"
}

function kc-delete-namespace-contents(){
  kc delete deployment --all -n="$1" && kc delete svc --all -n="$1" && kc delete pod --all -n="$1" && kc delete job --all -n="$1"
}



#Json Lint
function json_lint(){
  echo "$1" | python -mjson.tool
}
