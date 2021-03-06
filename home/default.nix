{ config, pkgs, lib, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "shaw";
    homeDirectory = "/home/shaw";
    stateVersion = "21.03";
  };
  news.display = "silent";

  nixpkgs.config.allowUnfree = true;

  xdg = {
    enable = true;
    mime.enable = true;
  };

  fonts.fontconfig.enable = true;

  # ugh, how do we pass in pkgsUnstable ?
  programs.go.package = pkgsUnstable.go_1_16;
  programs.qutebrowser.package = pkgsUnstable.qutebrowser;

  imports = [
    # settings has to go first as the config there controls aspects of the
    # pkg configurations below it.
    ../modules/settings.nix
    ../personal/programs/work.nix
    ./alacritty.nix
    ./aws-cli.nix
    ./aws-vault.nix
    ./bat.nix
    ./cdp.nix
    ./cmus
    ./dircolors
    ./direnv
    ./dunst.nix
    ./gruf.nix
    ./go.nix
    ./gopass.nix
    ./k9s
    ./keychain.nix
    ./kubectl.nix
    ./i3.nix
    ./i3lock-color.nix
    ./insync.nix
    ./polybar.nix
    ./tmux
    ./glow.nix
    ./git.nix
    ./fzf.nix
    ./bash.nix
    ./ranger
    ./rofi.nix
    ./spotify.nix
    ./qutebrowser
    ./weechat.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    autotiling
    pkgsUnstable.buf
    pkgsUnstable.calibre
    cloudflared
    ctags
    ctlptl
    dante
    dbeaver
    diffstat
    docker-compose
    networkmanager_dmenu
    dunst
    element-desktop
    entr
    gimp
    gnupg
    hugo
    insync
    pkgsUnstable.kind
    kubernetes-helm
    gitAndTools.hub
    pkgsUnstable.golangci-lint
    kubectx
    ledger-live-desktop
    libreoffice
    pkgsUnstable.i3-ratiosplit
    maim
    mpv
    neomutt
    nixfmt
    nodejs-12_x
    nodePackages.eslint
    packer
    powerline-go
    perl532Packages.FileMimeInfo
    prototool
    python3
    readline
    rnix-lsp
    shellcheck
    shfmt
    slack
    ssh-agents
    standardnotes
    system-san-francisco-font
    pkgsUnstable.tilt
    tdesktop
    pkgsUnstable.tmuxinator
    tree
    urlview
    w3m
    wmctrl
    xautolock
    xclip
    xdg_utils
    zoom-us
    yarn
  ];

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc-Dark";
    };
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    gtk3 = {
      bookmarks = [
        "file:///home/shaw/Documents"
        "file:///home/shaw/Downloads"
        "file:///home/shaw/Music"
        "file:///home/shaw/Pictures"
      ];
    };
  };

  services.unclutter.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };
  # Compositor to prevent screen tearing until modesetting gets in:
  #   https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/24
  services.picom = {
    enable = true;
    vSync = true;
  };

  # see overlay
  programs.neovim = {
    enable = true;
    package = pkgsUnstable.neovim-unwrapped;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython3 = true;
    withNodeJs = true;
    extraPython3Packages = (ps: with ps; [ pynvim jedi ]);
    extraConfig = builtins.readFile ./config/init.vim;
    #prototool', { 'rtp': 'vim/prototool' }
    # need a later coc.nvim than unstable
#    plugins = with pkgsUnstable.vimPlugins; [
#       vim-colors-solarized
#       vim-airline
#       vim-airline-themes
#       vim-obsession
#       vim-peekaboo
#       quick-scope
#       vim-fugitive
#       {
#         plugin = vim-gitgutter;
#         config = "let g:gitgutter_git_executable = ${pkgs.git}/bin/git";
#       }
#       vimagit
#       vim-rhubarb
#       vim-surround
#       vim-commentary
#       vim-sort-motion
#       vim-sneak
#       supertab
#       coc-nvim
#       coc-json
#       coc-yaml
#       coc-python
#       coc-git
#       coc-tsserver
#       coc-tslint-plugin
#       coc-snippets
#       #coc-protobuf
#       neomake
#       tmux-complete-vim
#       vim-snippets
#       vim-autoformat
#       vim-rooter
#       vim-go
#       vim-fetch
#       fzf-vim
#       {
#         plugin = vim-polyglot;
#         config = "let g:polyglot_disabled = ['typescript']";
#       }
#       vim-lastplace
#       {
#         plugin = vim-markdown-composer;
#         config = "let g:markdown_composer_autostart = 0";
#         config = "let g:markdown_composer_browser="epiphany-browser";
#       }
#       vim-python-pep8-indent
#       vim-packer
#       vim-jsonnet
#       vim-tmux
#       vim-nix
#       typescript-vim
#       nerdtree
#    ];
  };

  # see overlay
  programs.powerline-go = {
    enable = true;
    modules = [ "perms" "venv" "gitlite" "ssh" "cwd" ];
    newline = false;
    settings = {
      cwd-mode = "dironly";
      max-width = 65;
      priority = "root,perms,venv,git-branch,exit,cwd";
    };
  };
  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
  };
  home.file.".local/share/applications" = {
    source = ./misc/desktop;
    recursive = true;
  };
  home.file.".ssh/config".source = ../personal/ssh/config;
  home.file.".pypirc".source = ../personal/pypi/pypirc;
  home.activation.linkMyFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ln -sfT $VERBOSE_ARG $CLOUD_ROOT/Documents /home/shaw/Documents
    $DRY_RUN_CMD ln -sfT $VERBOSE_ARG $CLOUD_ROOT/Music /home/shaw/Music
    $DRY_RUN_CMD ln -sfT $VERBOSE_ARG $CLOUD_ROOT/Pictures /home/shaw/Pictures

    # qutebrowser writes to these so cannot be in the nix store- having them synced across
    # desktops automatically is also nice. Have to do this after sync or qutebrowser will
    # autocreate and then you've got a mess.
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG $XDG_CONFIG_HOME/qutebrowser/bookmarks
    if [ -f $DOCUMENTS/apps/qutebrowser/quickmarks ]; then
      $DRY_RUN_CMD ln -sf $VERBOSE_ARG $DOCUMENTS/apps/qutebrowser/quickmarks $XDG_CONFIG_HOME/qutebrowser/quickmarks
    fi
    if [ -f $DOCUMENTS/apps/qutebrowser/bookmarks ]; then
      $DRY_RUN_CMD ln -sf $VERBOSE_ARG $DOCUMENTS/apps/qutebrowser/bookmarks $XDG_CONFIG_HOME/qutebrowser/bookmarks/urls
    fi
    if [ ! -d $XDG_DATA_HOME/nvim/black ]; then
      $DRY_RUN_CMD mkdir -p $XDG_DATA_HOME/nvim/black
      $DRY_RUN_CMD python3 -m venv $XDG_DATA_HOME/nvim/black
      $DRY_RUN_CMD $XDG_DATA_HOME/nvim/black/bin/pip3 install black
    fi
    # import public/private personal keys. Create $GNUPGHOME directory if not exists
    # i.e., gpg --import private.key ... then gpg --edit-key {KEY} trust quit, where key is output from the previous import

    if [ ! -z $XDG_DATA_HOME ]; then
      if [ ! -d $XDG_DATA_HOME/bash ]; then
        $DRY_RUN_CMD mkdir -p $XDG_DATA_HOME/bash
      fi
    fi

    if [ ! -f $XDG_DATA_HOME/nvim/site/autoload/plug.vim ]; then
      $DRY_RUN_CMD echo "Installing plug for neovim.."
      $DRY_RUN_CMD sh -c 'curl -fLo $XDG_DATA_HOME/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    fi

    if [ ! -d $PASSWORD_STORE_DIR ]; then
      $DRY_RUN_CMD echo "Cloning password-store.."
      $DRY_RUN_CMD git clone git@github.com:svrana/password-store $PASSWORD_STORE_DIR
    fi

    $DRY_RUN_CMD mkdir -p ~/.cache/neomutt/{headers,messages}
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG $PERSONAL/c1/lint.sh $HOME/.local/bin/lint.sh
  '';
  xdg.configFile."nvim" = {
    source = ./config/nvim;
    recursive = true;
  };
  xdg.configFile."neomutt" = {
    source = ./config/neomutt;
    recursive = true;
  };
  xdg.configFile."inputrc".source = ./config/inputrc;
  xdg.configFile."psql/config".source = ./config/psql/psqlrc;
  xdg.configFile."npm/npmrc" = {
    text = ''
      python=python
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      tmp=''${XDG_RUNTIME_DIR}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
    '';
  };
  xdg.configFile."fd/ignore".text = ''
    vendor
    pb
  '';
  xdg.configFile."tmuxinator/work.yml".source = ./config/tmux/work.yml;

 xdg.mimeApps = {
   enable = true;
   defaultApplications = {
     "text/html" = "org.qutebrowser.qutebrowser.desktop";
     "x-scheme-handler/ftp" = "org.qutebrowser.qutebrowser.desktop";
     "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
     "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
     "x-scheme-handler/slack" = "slack.desktop";
     "x-scheme-handler/zoommtg" = "us.zoom.Zoom.desktop";
     "x-scheme-handler/element" = "element-desktop.desktop";
   };
 };
 xdg.configFile."networkmanager-dmenu/config.ini".text = ''
   [dmenu]
     dmenu_command = rofi -dmenu
     compact = true
     rofi_highlight = True
     wifi_chars = ▂▄▆█
 '';

 systemd.user.services.autocutsel = {
   Unit.Description = "AutoCutSel";
   Install = {
     WantedBy = [ "graphical-session.target" ];
   };
   Service = {
     Type = "forking";
     Restart = "always";
     RestartSec = 2;
     ExecStartPre = "${pkgs.autocutsel}/bin/autocutsel -selection CLIPBOARD -fork";
     ExecStart = "${pkgs.autocutsel}/bin/autocutsel -selection PRIMARY -fork";
   };
 };

 systemd.user.services.i3-ratiosplit = {
   Unit = {
     Description = "i3-ratiosplit";
     After = [ "graphical-session-pre.target" ];
     PartOf = [ "graphical-session.target" ];
   };
   Install = { WantedBy = [ "graphical-session.target" ]; };
   Service = {
     Type = "simple";
     ExecStart="${pkgs.bash}/bin/bash -c 'PATH=$PATH:${pkgs.i3-gaps}/bin ; ${pkgsUnstable.i3-ratiosplit}/bin/i3-ratiosplit'";
     RestartSec = 2;
     Restart = "always";
   };
 };

 # upstream
 # xresources.path = "${config.home.homeDirectory}/.config/Xresources";
}
