{ config, pkgs, lib, ... }:

let
  pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  # Let Home Manager install and manage itself.
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

  imports = [
    # settings has to go first as the config there controls aspects of the
    # pkg configurations below it.
    ./modules/settings.nix
    ./personal/programs/work.nix
    ./programs/alacritty.nix
    ./programs/bat.nix
    ./programs/cdp.nix
    ./programs/dircolors
    ./programs/direnv
    ./programs/dunst.nix
    ./programs/gruf.nix
    ./programs/go.nix
    ./programs/keychain.nix
    ./programs/i3.nix
    ./programs/polybar.nix
    ./programs/tmux
    ./programs/git.nix
    ./programs/fzf.nix
    ./programs/bash.nix
    ./programs/spotify.nix
  ];

  home.packages = with pkgs; [
    aerc
    alacritty
    appimage-run
    # amazon-ecr-credential-helper, where the binary?
    awscli
    aws-vault
    autocutsel
    autotiling
    cachix
#    ctlptl
    cmus
    ctags
    dante
    dbeaver
    gitAndTools.diff-so-fancy
    docker-compose
    dunst libnotify
    fd
    file
    firefox
    gcalcli
    gcc
    glow
    gopass
    gnumake
    gnupg
    kubernetes-helm
    hsetroot
    htop
    #pkgsUnstable.python37Packages.goobook
    gitAndTools.hub
    i3lock-color
    insync
    jq
    kbfs
    keybase
    keybase-gui
    kubectl
    kubectx
    k9s
    libreoffice
    lesspipe
    lsof
    lshw
    man
    neofetch
    openssl
    # couldn't get the override working so forked nixpkgs and installed with nix-env after adding directory to .nix-defexpr
#    pulumi-bin
    gnome3.nautilus
    gnome3.eog
#    khard
    pkgsUnstable.minikube
#    manix
    nixfmt
    nodejs-12_x
    nodePackages.eslint
    openvpn
    packer
    pciutils
    powerline-go
    psmisc
    prototool
    python3
    ranger
    readline
    gnome3.rhythmbox
    gnome3.gnome-screenshot
    ripgrep
    rofi
    rnix-lsp
    shellcheck
    shfmt
    slack
#    spotify-tui
    ssh-agents
#    standardnotes
    system-san-francisco-font
    pkgsUnstable.tilt
    tmate
    tmuxinator
    usbutils
    weechat
    w3m
    wirelesstools
    wmctrl
    xautolock
    xclip
    xdg_utils
    zoom-us
    unzip
    yarn
    zip
  ];

  gtk = {
    enable = true;
    # theme = {
    #   package = pkgs.numix-solarized-gtk-theme;
    #   name = "NumixSolarizedDarkCyan";
    # };
    # iconTheme = {
    #   package = pkgs.paper-icon-theme;
    #   name = "Paper";
    # };
    gtk3 = {
      bookmarks = [
        "file:///home/shaw/Documents"
        "file:///home/shaw/Downloads"
        "file:///home/shaw/Music"
        "file:///home/shaw/Pictures"
      ];
    };
  };

  services.keybase.enable = true;
  services.unclutter.enable = true;
  services.kbfs = {
    enable = true;
    mountPoint = ".cache/keybase";
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };
  # password prompt doesn't come up
  # services.spotifyd = {
  #   enable = true;
  #   settings = {
  #     global = {
  #       username = "shaversports";
  #       # don't get prompted for password...
  #       password_cmd = "${pkgs.gopass}/bin/gopass show spotify.com | ${pkgs.coreutils}/bin/head -1";
  #     };
  #   };
  # };

  # do i need this? pass seems faster after adding
  # systemd.user.services.gnome-keyring = {
  #   enable = true;
  #   type = [ "secrets" ];
  # };

  # Compositor to prevent screen tearing until modesetting gets it, perhaps here:
  #   https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/24
  services.picom = {
    enable = true;
    vSync = true;
  };

  # see overlay
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withPython = false;
    withPython3 = true;
    extraPython3Packages = (ps: with ps; [ pynvim ]);
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
  programs.qutebrowser = {
    enable = true;
    extraConfig = builtins.readFile ./config/qutebrowser/config.py;
  };
  programs.zathura = {
    enable = true;
    extraConfig = builtins.readFile ./config/zathura-solarized-dark.rc;
  };
  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
  };
  home.file.".local/share/applications" = {
    source = ./misc/desktop;
    recursive = true;
  };
  home.file.".ssh/config".source = ./personal/ssh/config;
  home.file.".pypirc".source = ./personal/pypi/pypirc;
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
    if [ ! -d $APPS/solarized-everything-css ]; then
      git clone git@github.com:alphapapa/solarized-everything-css.git $APPS/solarized-everything-css
    fi
    if [ ! -d $APPS/aerc ]; then
      # remove after nixifying aerch config
      git clone https://git.sr.ht/~sircmpwn/aerc $APPS/aerc
    fi
  '';
  home.activation.copyAercAccounts =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      install -D -m600 ${
        ./personal/aerc/accounts.conf
      } $XDG_CONFIG_HOME/aerc/accounts.conf
    '';
  xdg.configFile."nvim" = {
    source = ./config/nvim;
    recursive = true;
  };
  xdg.configFile."ranger" = {
    source = ./config/ranger;
    recursive = true;
  };
  xdg.dataFile."qutebrowser/userscripts/qute-pass-mod".source =
    ./config/qutebrowser/qute-pass-mod.py;
  xdg.configFile."weechat/weechat.conf".source = ./config/weechat.conf;
  xdg.configFile."inputrc".source = ./config/inputrc;
  xdg.configFile."psql/config".source = ./config/psql/psqlrc;
  xdg.configFile."rofi/config" = {
    text = ''
      rofi.theme: solarized
      rofi.font: SFNS ${toString config.settings.rofiFontSize}
      rofi.columns: 1
      rofi.bw: 0
      rofi.eh: 1
      rofi.hide-scrollbar: true
    '';
  };
  xdg.configFile."aerc" = {
    source = ./config/aerc;
    recursive = true;
  };
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
  xdg.configFile."cmus/rc".source = ./config/cmus.rc;
  xdg.configFile."k9s/skin.yml" = { source = ./config/k9s/skin.yml; };
  xdg.configFile."tmuxinator/work.yml".source = ./config/tmux/work.yml;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/ftp" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
    };
  };
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
  # systemd.user.services.minikube = {
  #   Unit.Descrption = "minikube development cluster";
  #   Service = {
  #     Type = "oneshot";
  #     RemainAfterExit = "yes";
  #     ExecStart = "${pkgsUnstable.minikube}/bin/minikube start";
  #     ExecStop = "${pkgsUnstable.minikube}/bin/minikube stop";
  #   };
  # };
}
