{ pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    userName = "Shaw Vrana";
    userEmail = "shaw@vranix.com";
    aliases = {
      rename = "commit --reset-author --amend";
      co = "checkout";
      ci = "commit";
      ciaa = "commit -a --amend";
      cia = "commit --amend";
      st = "status";
      f = "fetch";
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
      lg =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      latest = "diff HEAD~1 HEAD";
      home = ''config user.email "shaw@vranix.com"'';
      hg =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      fr = "!f() { git fetch origin main && git rebase origin/main; }; f";
      fro = "!f() { git fetch origin master && git rebase origin/master; }; f";
      new = ''!f() { git checkout -b "$@" --track origin/main; }; f'';
      patch = "!git --no-pager diff --no-color";
    };
    lfs = { enable = true; };
    extraConfig = {
      url."git@github.com:".insteadOf = "https://github.com";
      diff-so-fancy = { stripLeadingSymbols = false; };
      core = { pager = "diff-so-fancy | less --tabs=4 -RFX"; };
      merge = { tool = "vimdiff"; };
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
      # core = {
      #    pager = "delta";
      # };
      # interactive = {
      #   "diffFilter" = "delta --color-only";
      # };
    };
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
