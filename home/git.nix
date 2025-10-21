{ pkgs, lib, ... }:
let
  diffSoFancy = "${lib.getExe pkgs.gitAndTools.diff-so-fancy}";
in
{
  programs.git = {
    enable = true;
    signing = {
      key = "220B8643296AB53D";
      signByDefault = false;
    };
      settings = {
        user.name = "Shaw Vrana";
        user.email = "shaw@vranix.com";
        alias = {
          rename = "commit --reset-author --amend";
          co = "checkout";
          ci = "commit";
          ciaa = "commit -a --amend";
          cia = "commit --amend";
          mt = "mergetool";
          st = "status";
          ps = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
          pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
          cat = "cat-file";
          b = "branch --color -v";
          changes = "diff --name-status -r";
          diffstat = "diff --stat -r";
          whois = ''
          !sh -c 'git log -i -1 --pretty="format:%an <%ae>
          " --author="$1"' -'';
          whatis = "show -s --pretty='tformat:%h (%s, %ad)' --date=short";
          edit-unmerged =
            "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; vim `f`";
          add-unmerged =
            "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; git add `f`";
          lg = "log --pretty=format:'%C(cyan)%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
          latest = "diff HEAD~1 HEAD";
          home = ''config user.email "shaw@vranix.com"'';
          work = ''config user.email "shaw@vrana.com"'';
          hg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
          fr = "!f() { git fetch origin main && git rebase origin/main; }; f";
          fro = "!f() { git fetch origin master && git rebase origin/master; }; f";
          new = ''!f() { git checkout -b "$@" --track origin/main; }; f'';
          patch = "!git --no-pager diff --no-color";
          cb = "!sh $HOME/.local/bin/cb";
          wt = "worktree";
          cln ="clean -fd";
        };
      init = {
        defaultBranch = "main";
      };
      #url."git@github.com:".insteadOf = "https://github.com";
      #url."git@github.com:bommie".insteadOf = "https://github.com/bommie";
      diff-so-fancy = { stripLeadingSymbols = false; };
      core = { pager = ''${diffSoFancy} | less --tabs=4 -RFX''; };
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
        prompt = "false";
        keepBackup = "false";
      };
      credential = { helper = "cache"; };
      push = { default = "simple"; };

      color = { ui = true; };
      color."diff-highlight" = { oldNormal = "red bold"; };
      color."status" = {
        added = "yellow";
        changed = "green";
        untracked = "cyan reverse";
        branch = "magenta";
      };
      color."branch" = {
        current = "yellow black";
        local = "yellow";
        remote = "magenta";
      };
      color."diff" = {
        meta = "yellow";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
        whitespace = "red reverse";
        commit = "yellow bold";
      };
      advice = {
        skippedCherryPicks = false;
      };
      # core = {
      #    pager = "delta";
      # };
      # interactive = {
      #   "diffFilter" = "delta --color-only";
      # };
    };
    lfs = { enable = true; };
    ignores = [
      ".gruf.*"
      "cscope.out"
      ".lint.pot"
      ".venv"
      ".ruby-version"
      ".ruby-gemset"
      ".envrc"
      ".direnv"
      ".*@neomake*"
      ".ignore"
      ".gonvim"
    ];
    attributes = [
      "*.c     diff=cpp"
      "*.h     diff=cpp"
      "*.c++   diff=cpp"
      "*.h++   diff=cpp"
      "*.cpp   diff=cpp"
      "*.hpp   diff=cpp"
      "*.cc    diff=cpp"
      "*.hh    diff=cpp"
      "*.css   diff=css"
      "*.html  diff=html"
      "*.xhtml diff=html"
      "*.ex    diff=elixir"
      "*.exs   diff=elixir"
      "*.go    diff=golang"
      "*.php   diff=php"
      "*.pl    diff=perl"
      "*.py    diff=python"
      "*.md    diff=markdown"
      "*.rb    diff=ruby"
      "*.rake  diff=ruby"
      "*.rs    diff=rust"
      "*.lisp  diff=lisp"
      "*.el    diff=lisp"
    ];
  };

  programs.bash.initExtra = ''
    source ${pkgs.git}/share/bash-completion/completions/git
    __git_complete g __git_main
    alias g='git'
  '';
}
