alias path='echo -e ${PATH//:/\\n}'

is() {
    if [ -z "$1" ]; then
        return
    fi

    ps -ef | head -n1 ; ps -ef | grep -v grep | grep "$@" -i --color=auto;
}

md() {
    [ -z "$1" ] && return
    mkdir "$1" && cd "$1"
}

s() {
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

linkme() {
    [ -z "$1" ] && return
    readlink -f $(which "$1")
}

# run command until it succeeds
loopit() {
    if [ -z "$1" ]; then
        echo 'Must provide command to loop'
        return 1
    fi

    while true; do
        $(echo "$@") && break
        sleep .05 # allow ctrl-c out
    done
}

# run command until it fails
loopitfail() {
    if [ -z "$1" ]; then
        echo 'Must provide command to loop'
        return 1
    fi

    while true; do
        $(echo "$@") || break
        sleep .05 # allow ctrl-c out
    done
}

flakify() {
  if [ ! -e flake.nix ]; then
    nix flake init -t github:numtide/blueprint
  elif [ ! -e .envrc ]; then
    echo "use flake" > .envrc
    direnv allow
  fi
  ${EDITOR:-vim} devshell.nix
}
