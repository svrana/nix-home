{ config, pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home = {
    username = "shaw";
    homeDirectory = "/home/shaw";
    stateVersion = "21.03";
    # workaround for https://github.com/nix-community/home-manager/issues/2219
    keyboard = null;
    sessionPath = [ "/home/shaw/.local/bin" ];
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
    #../personal/programs/work.nix
    ./aerc
    ./alacritty.nix
    ./aws-cli.nix
    ./aws-vault.nix
    ./bat.nix
    ./cdp.nix
    ./cmus
    ./dircolors
    ./direnv
    ./docker.nix
    ./dunst.nix
    ./foot.nix
    ./gruf.nix
    ./go.nix
    ./gopass.nix
    #./haskell.nix
    #./helm.nix
    ./k9s
    #./keybase.nix
    ./keychain.nix
    ./kubectl.nix
    ./nvim
    ./sway.nix
    ./tmux
    ./glow.nix
    ./go.nix
    ./git.nix
    ./fzf.nix
    ./bash.nix
    ./ranger
    ./rofi.nix
    ./spotify.nix
    ./qutebrowser
    #./weechat.nix
    ./zathura.nix
  ];



  home.packages = with pkgs; [
    autotiling
    cargo
    rustc
    dante
    dbeaver
    discord
    diffstat
    docker-compose
    emacs
    exa
    networkmanager_dmenu
    cachix
    ctlptl
    google-chrome
    gh
    niv
    element-desktop
    entr
    evince
    gimp
    gnupg
    kind
    pkgs.kubernetes-helm
    gitAndTools.hub
    grpcurl
    kubectx
    ledger-live-desktop
    i3-ratiosplit
    imv
    libsixel # for img2sixel
    maim
    mpv
    gnome.nautilus
    gnome.eog
    libreoffice
    nixfmt
    nixpkgs-review
    packer
    pulumi-bin
    prototool
    python3
    readline
    rnix-lsp
    shellcheck
    shfmt
    spotify-tui
    slack
    ssh-agents
    standardnotes
    system-san-francisco-font
    sysz
    tdesktop
    tilt
    tealdeer
    tmuxinator
    tree
    urlview
    w3m
    wmctrl
    xdg-utils
    zoom
    yarn
    bc
    vanilla-dmz
    yq
    buf
    #go-migrate
    nodejs
    typescript
    postman
    protoc-gen-validate
    #cilium-cli
    #certbot
    #istioctl
    luakit

    # sway specific
    avizo
    clipman
    swaylock
    swayidle
    wl-clipboard
    wf-recorder # i.e., wf-recorder -g "$(slurp)"
    swaybg
    waybar
    wtype
    slurp
    grim
    brightnessctl
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

  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.config/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "gnome3";
    defaultCacheTtl = 8 * 60 * 60;
    maxCacheTtl = 8 * 60 * 60;
  };
  services.syncthing.enable = true;
  # see overlay
  programs.powerline-go = {
    enable = false;
    modules = [ "ssh" "perms" "venv" "gitlite" "cwd" ];
    newline = false;
    settings = {
      cwd-mode = "dironly";
      max-width = 65;
      priority = "ssh,perms,venv,gitlite,cwd";
    };
  };
  programs.starship = {
    enable = true;
    settings = {
      command_timeout = 20;
      # format = lib.concatStrings [
      #   "$all"
      #   "$directory"
      #   "$character"
      # ];
      character = {
        success_symbol = "[❯](#859900)";
        error_symbol = "[❯](#dc322f)";
        #success_symbol = "[➜](#859900)";
        #error_symbol = "[➜](#dc322f)";
      };
      kubernetes = {
        disabled = false;
        context_aliases = {
          kind-b6 = "dev";
        };
      };
      terraform = {
        disabled = true;
      };
      nix_shell = {
        format = "via [$symbol]($style) ";
      };
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
  home.file.".config/doom" = {
    source = ./doom;
    recursive = true;
  };
  #home.file.".ssh/config".source = ../personal/ssh/config;
  #home.file.".pypirc".source = ../personal/pypi/pypirc;
  home.activation.linkMyFiles = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ln -sfT $VERBOSE_ARG $CLOUD_ROOT/Documents ${config.home.homeDirectory}/Documents
    $DRY_RUN_CMD ln -sfT $VERBOSE_ARG $CLOUD_ROOT/Music ${config.home.homeDirectory}/Music
    $DRY_RUN_CMD ln -sfT $VERBOSE_ARG $CLOUD_ROOT/Pictures ${config.home.homeDirectory}/Pictures

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
    # not sure if i'm using this anymore
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

    if [ ! -d $PASSWORD_STORE_DIR ]; then
      $DRY_RUN_CMD echo "Cloning password-store.."
      $DRY_RUN_CMD git clone git@github.com:svrana/password-store $PASSWORD_STORE_DIR
    fi

    if [ ! -d $PROJECTS/cdp ]; then
      $DRY_RUN_CMD echo "Cloning cdp.."
      $DRY_RUN_CMD git clone git@github.com:svrana/cdp $PROJECTS/cdp
    fi

    if [ ! -d $PROJECTS/neosolarized.nvim ]; then
      $DRY_RUN_CMD echo "Cloning neosolarized.."
      $DRY_RUN_CMD git clone git@github.com:svrana/neosolarized.nvim $PROJECTS/neosolarized.nvim
    fi

    if [ ! -d $PROJECTS/gruf ]; then
      $DRY_RUN_CMD echo "Cloning gruf.."
      $DRY_RUN_CMD git clone git@github.com:svrana/gruf $PROJECTS/gruf
    fi

    if [ ! -d ~/.config/emacs ]; then
      $DRY_RUN_CMD git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    fi
    if [ ! -f ~/.local/bin/doom ]; then
      ln -s ~/.config/emacs/bin/doom ~/.local/bin/doom
    fi

    if [ -d $XDG_DATA_HOME/aerc ]; then
      $DRY_RUN_CMD cp $PERSONAL/aerc/accounts.conf $XDG_DATA_HOME/aerc
    fi
  '';
  xdg.configFile."nvim" = {
    source = ./config/nvim;
    recursive = true;
  };
  xdg.configFile."inputrc".source = ./config/inputrc;
  xdg.configFile."psql/config".source = ./config/psql/psqlrc;
  xdg.configFile."npm/npmrc" = {
    text = ''
      python=python
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
    '';
  };
  xdg.configFile."fd/ignore".text = ''
    vendor
    pb
  '';
  #xdg.configFile."tmuxinator/work.yml".source = ./config/tmux/work.yml;
  xdg.configFile."tmuxinator/project.yml".source = ./config/tmux/project.yml;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      #"image/jpeg" = "imv.desktop";
      "image/jpeg" = "org.gnome.eog.desktop";
      "image/png" = "org.gnome.eog.desktop";
      "image/gif" = "org.gnome.eog.desktop";
      #"application/pdf" = "org.evince.evince.desktop";
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

  xresources = {
    extraConfig = "Xft.dpi: ${toString config.settings.x.dpi}";
    path = "${config.home.homeDirectory}/.config/X11/Xresources";
  };

  programs.z-lua = {
    enable = true;
    enableAliases = true;
    options = [ "enhanced" "fzf" "once" ];
  };

  programs.less = {
    enable = true;
    keys = ''
    '';
  };

  programs.mpv = {
    enable = true;
    config = {
      gpu-context = "wayland";
      background = "#002b36";
      force-window = "immediate";
    };
  };

  programs.htop = {
    enable = true;
    settings = {
      sort-direction = "0";
      color-scheme = "0";
    };
  };

  # Set name in icons theme, for compatibility with AwesomeWM etc. See:
  # https://github.com/nix-community/home-manager/issues/2081
  # https://wiki.archlinux.org/title/Cursor_themes#XDG_specification
  home.file.".icons/default/index.theme".text = ''
    [icon theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=Vanilla-DMZ
  '';

  home.sessionVariables = {
    GTK_THEME = "Arc-Dark";
    MOZ_ENABLE_WAYLAND = "1";
  };

  xdg.configFile."electron-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
  '';
  xdg.configFile."imv/config".text = ''
    [options]
      background=002b36
  '';
  # solarize it
  xdg.configFile."Element/config.json".text = ''
        {
        "settingDefaults": {
            "custom_themes": [
                {
                    "name": "Example theme",
                    "colors": {
                        "primary-color": "#9F8652"
                    }
                },
                {
                    "name": "Another theme",
                    "colors": {
                        "primary-color": "#526A9E"
                    }
                }
            ]
        },
        "show_labs_settings": true
    }
  '';
  xdg.configFile."luakit" = {
    source = ./luakit;
    recursive = true;
  };
}
