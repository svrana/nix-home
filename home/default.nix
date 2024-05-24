{ config, pkgs, lib, wayland-pipewire-idle-inhibit, ... }:
let
  inherit (config) my;
  c = config.my.theme.withHashTag;
  colors = config.my.theme;
in {
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the paths it should manage.
  home = {
    username = "shaw";
    homeDirectory = "/home/shaw";
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
    ./aerc
    ./alacritty.nix
    ./aws-cli.nix
    ./aws-vault.nix
    ./bash.nix
    ./bat.nix
    ./cdp.nix
    ./cmus
    ./dircolors
    ./direnv
    ./docker.nix
    ./dunst.nix
    ./foot.nix
    ./fzf.nix
    ./git.nix
    ./glow.nix
    ./go.nix
    ./gopass.nix
    ./gruf.nix
    ./k9s
    ./keybase.nix
    ./keychain.nix
    ./kubectl.nix
    ./neovim.nix
    ./qutebrowser
    ./readline.nix
    ./rust.nix
    ./shell.nix
    ./spotify.nix
    ./sway.nix
    ./tmux
    ./zathura.nix

    ./packages.nix # big list o' packages
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
        "file://${config.home.homeDirectory}/Documents"
        "file://${config.home.homeDirectory}/Downloads"
        "file://${config.home.homeDirectory}/Music"
        "file://${config.home.homeDirectory}/Pictures"
      ];
    };
    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    };
  };

  programs.gpg = {
    enable = true;
    homedir = "${config.home.homeDirectory}/.config/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryPackage = pkgs.pinentry-gnome3;
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
      character = {
        success_symbol = "[❯](${c.base0B})";
        error_symbol = "[❯](${c.base08})";
      };
      kubernetes = {
        disabled = false;
        contexts = [
          { context_pattern = "kind-b6"; context_alias = "b6"; }
        ];
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
    # to export:
    #   gpg --output private.pgp --armor --export-secret-key shaw@vranix.com
    # to import:
    #   gpg --import private.key ... then gpg --edit-key {KEY} trust quit, where key is output from the previous import

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
      $DRY_RUN_CMD mkdir -p $HOME/.config/nvim/after/pack/foo/start
      $DRY_RUN_CMD ln -sf $PROJECTS/neosolarized.nvim $HOME/.config/nvim/after/pack/foo/start/neosolarized.nvim
    fi

    if [ ! -d $PROJECTS/gruf ]; then
      $DRY_RUN_CMD echo "Cloning gruf.."
      $DRY_RUN_CMD git clone git@github.com:svrana/gruf $PROJECTS/gruf
    fi

    if [ -d $XDG_DATA_HOME/aerc ]; then
      $DRY_RUN_CMD cp $PERSONAL/aerc/accounts.conf $XDG_DATA_HOME/aerc
    fi
  '';
  xdg.configFile."nvim" = {
    source = ./config/nvim;
    recursive = true;
  };
  xdg.configFile."psql/config".source = ./config/psql/psqlrc;
  xdg.configFile."npm/npmrc" = {
    text = ''
      python=python
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      logs-dir=''${XDG_STATE_HOME}/npm/logs
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
      dmenu_command = fuzzel --dmenu
      compact = true
      rofi_highlight = True
      wifi_chars = ▂▄▆█
  '';

  xresources = {
    extraConfig = "Xft.dpi: ${toString my.x.dpi}";
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
      background = c.base00;
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

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font="${my.fuzzel.font}";
        layer = "overlay";
        width=my.fuzzel.width;
        inner-pad=my.fuzzel.inner_pad;
        prompt="'❯ '";
      };
      key-bindings = {
        cancel="Control+bracketleft";
        delete-prev-word="Control+w";
        delete-line="Control+u";
      };
      colors.background = "${colors.base00}ff";
      colors.border = "${colors.base0C}ff";
      colors.selection = "${colors.base01}ff";
    };
  };

  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    icons = true;
    extraOptions = [ "--group-directories-first" ];
  };

  programs.yazi = {
    enable = true;
    theme = {
      manager = {
        border_style = { fg = "${c.base04}"; bg = "${c.base00}"; };
        hovered = { fg = "${c.base07}"; bg = "${c.base01}"; };
        previewed_hovered = { fg = "${c.base07}"; bg = "${c.base01}"; };
      };
    };
  };

  # Set name in icons theme. Details:
  #   https://github.com/nix-community/home-manager/issues/2081
  #   https://wiki.archlinux.org/title/Cursor_themes#XDG_specification
  #
  # This is working and looks better than the default.
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
      background=${colors.base00}
  '';
  # cannot get the custom themes to show, so just adding solarized via url
  xdg.configFile."Element/config.json".text = ''
    {
      "show_labs_settings": true
    }
  '';
  xdg.configFile."luakit" = {
    source = ./luakit;
    recursive = true;
  };
}
