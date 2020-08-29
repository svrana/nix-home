#!/bin/bash

# prompts for a y/n from user, returning 0 or 1 respectively
ask() {
    echo -n "$@" '[y/N] ' ; read ans

    case "$ans" in
        y*|Y*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Add newlines to path for readability
alias path='echo -e ${PATH//:/\\n}'
alias perlinc='perl -le "print for @INC"'
alias svi='sudo vi'
alias bzip='bzip2'
alias bunzip='bunzip2'
alias diff='diff -u'
alias rmkey='ssh-keygen -f "~/.ssh/known_hosts" -R'
alias upgrade='sudo apt update && sudo apt upgrade -y && sudo apt clean && sudo apt autoremove -y'
alias diskspace="du -S | sort -n -r |less"
alias kvswap='rm  ~/.local/share/nvim/swap/*'

md() {
    [ -z "$1" ] && return
    mkdir "$1" && cd "$1"
}

cores() {
    grep -c ^processor /proc/cpuinfo
}

s() {
    if [[ $# == 0 ]]; then
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

extract() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)   tar xjvf "$1"     ;;
            *.tar.gz)    tar xzvf "$1"     ;;
            *.tar.xz)    tar xvf "$1"      ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xvf "$1"      ;;
            *.tbz2)      tar xvjf "$1"     ;;
            *.tgz)       tar xvzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# view image in terminal. does not work with tmux :(
img () {
    w3m -o imgdisplay=/usr/lib/w3m/w3mimgdisplay "$1"
}


trim() {
    if [ -z "$1" ]; then
        # assume content comes from stdin if not from a parameter
        str=$(< /dev/stdin)
    else
        str="$1"
    fi

    # Usage: trim_string "   example   string    " or echo " fooo " | trim_string
    : "${str#"${str%%[![:space:]]*}"}"
    : "${_%"${_##*[![:space:]]}"}"
    printf '%s\n' "$_"
}

# Remove all invalid directories from PATH
#
# @return String PATH
PATH_clean() {
    local tmp=()
    for dir in $(split "$PATH" ":") ; do
        [ -d "$dir" ] && tmp+=("$dir")
    done
    local new_path
    new_path=$(join_by ':' "${tmp[@]}")
    export PATH="$new_path"
}

PATH_prepend() {
    [ -z "$1" ] && return

    local paths
    paths=$(split "$1" ":")
    for path in $paths ; do
        if [ ! -d "$path" ]; then
            continue
        fi
        if [ "${PATH#*${path}}" = "${PATH}" ]; then
            export PATH=$path:$PATH
        fi
    done
}

PATH_append() {
    [ -z "$1" ] && return

    local paths
    paths=$(split "$1" ":")
    for path in $paths ; do
        if [ ! -d "$path" ]; then
            continue
        fi
        if [ "${PATH#*${path}}" = "${PATH}" ]; then
            export PATH=$PATH:$path
        fi
    done
}

CDPATH_append() {
    [ -z "$1" ] && return

    local paths
    paths=$(split "$1" ":")
    for path in $paths ; do
        if [ "${CDPATH#*${path}}" = "${PATH}" ]; then
            export CDPATH=$CDPATH:$path
        fi
    done
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

# Search for a string in the files in all subdirectories of $PWD
sf() {
    if [ "$#" -lt 1 ]; then
        echo "Supply string to search for!"
        return 1
    fi
    printf -v search "%q" "$*"

    exclude="tags,.config,.git,node_modules,vendor,build,yarn.lock,*.sty,*.bst,*.coffee,dist,.berkshelf"
    rg_command='rg --smart-case --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --color "always" -g "!{'$exclude'}"'
    #echo "rg_commmand: $rg_command"
    files=$(eval "$rg_command" "$search" 2>/dev/null | fzf --height 80% --ansi --multi --reverse | awk -F ':' '{print $1":"$2":"$3}')
    files=$(echo "$files" | tr '\n' ' ' | sed -e 's/[[:space:]]*$//')
    [[ -n "$files" ]] && ${EDITOR:-vim} $files
}

download() {
    local url="$1"
    local output="$2"

    echo "Downloading from $url"

    curl -LsSo "$output" "$url" &> /dev/null
        #     │││└─ write output to file
        #     ││└─ show error messages
        #     │└─ don't show the progress meter
        #     └─ follow redirects
    return $?
}

split_to_array() {
   IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
   echo "${arr[@]}"
}

# Usage: split "string" "delimiter"
split() {
   IFS=$'\n' read -d "" -ra arr <<< "${1//$2/$'\n'}"
   printf '%s\n' "${arr[@]}"
}

join_by() {
    local d=$1 ; shift; echo -n "$1"; shift; printf "%s" "${@/#/$d}";
}

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}


bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
bind '"\C-g\C-r": "$(gr)\e\C-e\er"'
