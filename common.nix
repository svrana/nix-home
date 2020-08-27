{ config, pkgs, lib, ... }:

let
   pkgsUnstable = import <nixpkgs-unstable> {};
in
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

  home.sessionVariables = {
    # fixing locale errors when running some commands (like man, rofi, etc)
    # See https://github.com/rycee/home-manager/issues/354
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  nixpkgs.config.allowUnfree = true;
  xdg.enable = true;

  imports = [
    # settings has to go first as the config there controls aspects of the
    # pkg conigurations below it.
    ./modules/settings.nix

    ./personal/programs/sai.nix

    #./programs/alacritty.nix
    ./programs/bat.nix
    ./programs/cdp.nix
    ./programs/dircolors
    ./programs/direnv
    ./programs/dunst.nix
    ./programs/gruf.nix
    ./programs/go.nix
    ./programs/keychain.nix
    ./programs/k9s
    ./programs/polybar.nix
    ./programs/tmux
    ./programs/git.nix
    ./programs/fzf.nix

    ./programs/bash.nix
  ];

  home.packages = with pkgs; [
    pkgsUnstable.aerc
    # opengl apps doesn't work on non-nixos without some fudging which I didn't do (https://github.com/NixOS/nixpkgs/issues/9415)
    #pkgsUnstable.alacritty
    appimage-run
    # amazon-ecr-credential-helper, where the binary?
    awscli
    aws-vault
    autocutsel
    ctags
    dante
    dbeaver
    gitAndTools.diff-so-fancy
    docker-compose
    dunst
    fd
    firefox
    gnupg
    # helm # cores on me
    htop
    # didn't work on ubuntu, try again after switch
    #i3lock-color
    insync
    jq
    kbfs # for keybase
    keybase
    keybase-gui
    kubectl
    kubectx
    # need newer version for skin
    pkgsUnstable.k9s
    lesspipe
    man
    nodejs-12_x
    nodePackages.eslint
    openvpn
    packer
    pass
    pinentry-gtk2
    ranger
    readline
    ripgrep
    rofi
    shellcheck
    slack
    spotify
    ssh-agents
    tmate
    w3m
    wmctrl
    xautolock
    xclip
    xdg_utils
    zip
  ];

  gtk = {
    enable = true;
    # font = {
    #   name = "Noto Sans 10";
    #   package = pkgs.noto-fonts;
    # };
    # iconTheme = {
    #   name = "Adwaita";
    #   package = pkgs.gnome3.adwaita-icon-theme;
    # };
    # theme = {
    #   name = "Adapta-Nokto-Eta";
    #   package = pkgs.adapta-gtk-theme;
    # };
    gtk3 = {
      bookmarks = [
        "file:///home/shaw/Documents"
        "file:///home/shaw/Music"
        "file:///home/shaw/Pictures"
        "file:///home/shaw/Downloads"
      ];
    };
  };

  services.keybase.enable = true;

 # see lock on resume
 #
 # systemd.user.services.volumeicon = {
 #    Unit = {
 #      Description = "Volume Icon";
 #      After = [ "graphical-session-pre.target" ];
 #      PartOf = [ "graphical-session.target" ];
 #    };

 #    Install = {
 #      WantedBy = [ "graphical-session.target" ];
 #    };

 #    Service = {
 #      ExecStart = "${pkgs.volumeicon}/bin/volumeicon";
 #    };
 #  };


  #
  # xession.enable = true;
  # xsession.windowManager.i3 = {
  #   enable = true;
  #   package = "pkgs.i3-gaps";
  #   extraPackages = with pkgs; [
  #     i3lock-color
  #   ];
  # };

  #services.xclutter.enable = true;

  # Not quite new enough; missing CocTagFunc
  # pkgsUnstable.neovim = {
  #   enable = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  # };

  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
  };
  home.file.".local/share/fonts" = {
    source = ./fonts;
    recursive = true;
  };
  home.file.".local/share/applications" = {
    source = ./misc/desktop;
    recursive = true;
  };
  home.file.".rvmrc".text = ''
    rvm_autoupdate_flag=2
    export rvm_max_time_flag=20
    create_on_use_flag=1
    rvm_silence_path_mismatch_check_flag=1
  '';
  home.file.".ssh/config".source = ./personal/ssh/config;
  home.file.".pypirc".source = ./personal/pypi/pypirc;
  home.activation.linkMyFiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG $CLOUD_ROOT/Documents /home/shaw/Documents
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG $CLOUD_ROOT/Cloud/Music /home/shaw/Music
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG $CLOUD_ROOT/Pictures /home/shaw/Pictures

    $DRY_RUN_CMD cp $VERBOSE_ARG $PERSONAL/aerc/accounts.conf $XDG_CONFIG_HOME/aerc
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG $RCS/alacritty.yml $XDG_CONFIG_HOME/alacritty

    # qutebrowser writes to these so cannot be in the nix store- having them synced across
    # desktops automatically is also nice.
    $DRY_RUN_CMD mkdir -p $VERBOSE_ARG $XDG_CONFIG_HOME/qutebrowser/bookmarks
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG /home/shaw/Documents/apps/qutebrowser/quickmarks $XDG_CONFIG_HOME/qutebrowser/quickmarks
    $DRY_RUN_CMD ln -sf $VERBOSE_ARG /home/shaw/Documents/apps/qutebrowser/bookmarks $XDG_CONFIG_HOME/qutebrowser/bookmarks/urls
  '';
  xdg.configFile."X11/Xresources" = {
    text = ''
      Xft.antialias: true
      Xft.hinting:   true
      Xft.rgba:      rgb
      Xft.hintstyle: hintfull
      Xcursor.size: ${toString config.settings.cursorSize}
    '';
  };
  xdg.configFile."X11/Xmodmap" = {
    text = ''
      keycode 66 = Control_L
      clear Lock
    '';
  };
  xdg.configFile."X11/xinitrc" = {
    text = ''
      xmodmap ~/.config/X11/Xmodmap
      xrdb ~/.config/X11/Xresources
      dbus-run-session /usr/bin/i3
    '';
  };
  xdg.configFile."X11/xserverrc" = {
    text = ''
      #!/bin/sh
      exec /usr/bin/Xorg -nolisten tcp "$@" vt$XDG_VTNR
    '';
  };
  xdg.configFile."mimeapps.list".source = ./config/mimeapps.list;
  xdg.configFile."nvim" = {
    source = ./config/nvim;
    recursive = true;
  };
  xdg.configFile."ranger" = {
    source = ./config/ranger;
    recursive = true;
  };
  xdg.configFile."i3/config".source = ./config/i3config;
  #xdg.configFile."polybar/config".source = ./config/polybar-config.winfield;
  xdg.configFile."qutebrowser/config.py".source = ./config/qutebrowser/config.py;
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
      python=/usr/bin/python2
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      tmp=''${XDG_RUNTIME_DIR}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
    '';
  };
  # aerc complains about link perms
  # xdg.configFile."aerc/accounts.conf" = {
  #   source = ./personal/aerc/accounts.conf;
  # };
  xdg.configFile."cmus/rc".source = ./config/cmus.rc;
  xdg.configFile."spotifyd/spotifyd.conf".source = ./config/spotifyd.conf;

  # TODO:
  # virtualenv
  #   override k9s
  #   figure out prompt
  #     create the damn package yourself /home/shaw/Projects/nixpkgs/pkgs/applications/blockchains/quorum.nix for typical golang package
  #     or override the existing powerline-go
  #pkgs.powerline-go = pkgs.powerline-go.overrideAttrs (oldAttrs: rec {
  #  version = "1.51-svrana";
  #});
    # src = fetchFromGitHub {
    #   owner = "svrana";
    #   repo = pname;
    #   rev = "v{version}";
    # };
}
