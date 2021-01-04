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

  imports = [
    # settings has to go first as the config there controls aspects of the
    # pkg configurations below it.
    ../modules/settings.nix
    ../personal/programs/work.nix
    ./aerc
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
    pkgsUnstable.aerc
    alacritty
    autocutsel
    autotiling
    ctags
    dante
    dbeaver
    gitAndTools.diff-so-fancy
    docker-compose
    networkmanager_dmenu
    dunst
    feh
    gnupg
    kubernetes-helm
    gitAndTools.hub
    i3lock-color
    insync
    kubectx
    libreoffice
    #gnome3.eog
    pkgsUnstable.minikube
    maim
    nixfmt
    nodejs-12_x
    nodePackages.eslint
    packer
    powerline-go
    perl532Packages.FileMimeInfo
    prototool
    python3
    ranger
    readline
    gnome3.gnome-screenshot
    rofi-pass
    rnix-lsp
    shellcheck
    shfmt
    slack
    ssh-agents
    system-san-francisco-font
    pkgsUnstable.tilt
    tmuxinator
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
  '';
  xdg.configFile."nvim" = {
    source = ./config/nvim;
    recursive = true;
  };
  # xdg.configFile."ranger" = {
  #   source = ./config/ranger;
  #   recursive = true;
  # };
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
}
