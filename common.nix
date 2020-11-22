{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "shaw";
  home.homeDirectory = "/home/shaw";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
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
    ./personal/programs/sai.nix
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
    cmus
    ctags
    dante
    dbeaver
    gitAndTools.diff-so-fancy
    docker-compose
    dunst
    fd
    firefox
    gcalcli
    gcc
    glow
    gopass
    gnumake
    gnupg
    hsetroot
    htop
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
    lesspipe
    lsof
    man
    gnome3.nautilus
    nixfmt
    nodejs-12_x
    nodePackages.eslint
    openvpn
    packer
    pciutils
    pinentry
    powerline-go
    psmisc
    python3
    ranger
    readline
    gnome3.rhythmbox
    ripgrep
    rofi
    rnix-lsp
    shellcheck
    shfmt
    slack
    ssh-agents
    standardnotes
    system-san-francisco-font
    tmate
    tmuxinator
    usbutils
    w3m
    wirelesstools
    wmctrl
    xautolock
    xclip
    xdg_utils
    zoom-us
    zip
  ];

  gtk = {
    enable = true;
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
  services.kbfs.enable = true;
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
  };

  # do i need this? pass seems faster after adding
  # systemd.user.services.gnome-keyring = {
  #   enable = true;
  #   type = [ "secrets" ];
  # };

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
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG $CLOUD_ROOT/Documents /home/shaw/Documents
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG $CLOUD_ROOT/Music /home/shaw/Music
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG $CLOUD_ROOT/Pictures /home/shaw/Pictures

    # qutebrowser writes to these so cannot be in the nix store- having them synced across
    # desktops automatically is also nice. Have to do this after sync or qutebrowser will
    # autocreate and then you've got a mess.
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG $XDG_CONFIG_HOME/qutebrowser/bookmarks
    #$DRY_RUN_CMD ln -sf $VERBOSE_ARG $DOCUMENTS/apps/qutebrowser/quickmarks $XDG_CONFIG_HOME/qutebrowser/quickmarks
    #$DRY_RUN_CMD ln -sf $VERBOSE_ARG $DOCUMENTS/apps/qutebrowser/bookmarks $XDG_CONFIG_HOME/qutebrowser/bookmarks/urls
    if [ ! -d $XDG_DATA_HOME/nvim/black ]; then
      $DRY_RUN_CMD mkdir -p $XDG_DATA_HOME/nvim/black
      $DRY_RUN_CMD python3 -m venv $XDG_DATA_HOME/nvim/black
      $DRY_RUN_CMD $XDG_DATA_HOME/nvim/black/bin/pip3 install black
    fi
    # import public/private personal keys. Create $GNUPGHOME directory if not exists
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
  xdg.dataFile."qutebrowser/userscripts/qute-pass".source =
    ./config/qutebrowser/qute-pass;
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
}
