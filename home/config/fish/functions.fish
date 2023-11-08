#!/usr/bin/env fish

function is
    if count $argv > /dev/null
        ps -ef | head -n1 ; ps -ef | grep -v grep | grep $argv -i --color=auto
    end
end


function s
    if count $argv > /dev/null
        sudo "$argv"
    else
        sudo (history -p | head -n1)
    end
end

function md
    if count $argv > /dev/null
        mkdir "$argv" && cd "$argv"
    end
end


function is_in_git_repo
  git rev-parse HEAD > /dev/null 2>&1
end

# return the git project root or the current directory if not in a git repo.
function git_root
    git rev-parse --show-toplevel 2>/dev/null || pwd
end

function gf
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
end

function gh
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
end

function gb
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
end

function gr
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d\$'\t' -f1
end

# these do not work
bind "\er": redraw-current-line
bind \e\cf gf
bind "\Cg\Cb" "(gb)\e\C-e\er"
bind "\Cg\Ct" "(gt)\e\C-e\er"
bind "\Cg\Ch" "(gh)\e\C-e\er"
bind "\Cg\Cr" "(gr)\e\C-e\er"

function flakify
  if [ -e flake.nix ]
    nix flake new -t github:nix-community/nix-direnv .
  else if [ ! -e .envrc ]
    echo "use flake" > .envrc
    direnv allow
  end
  if set -q $EDITOR
      $EDITOR flake.nix
  else
    vim flake.nix
  end
end
