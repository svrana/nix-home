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

  # fixing locale errors when running some commands (like man, rofi, etc)
  # See https://github.com/rycee/home-manager/issues/354
  home.sessionVariables.LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";


  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules/settings.nix

    ./personal/programs/sai.nix

    # alacritty can find the glx lib
    #./programs/alacritty.nix
    ./programs/cdp.nix
    ./programs/dircolors
    ./programs/direnv
    ./programs/dunst.nix
    ./programs/gruf.nix
    ./programs/go.nix
    # cannot seem to register with gpg-agent
    #./programs/keychain.nix
    ./programs/k9s
    #./programs/polybar.nix
    ./programs/tmux
    ./programs/git.nix
    ./programs/fzf.nix

    ./programs/bash.nix
  ];

  home.packages = with pkgs; [
    aerc
    autocutsel
    ctags
    dbeaver
    dunst
    fd
    firefox
    gnupg
    jq
    kubectl
    kubectx
    k9s
    lesspipe
    man
    packer
    pass
    pinentry-gtk2
    readline
    ripgrep
    shellcheck
    ssh-agents
    wmctrl
  ];

  # Not quite new enough; missing CocTagFunc
  # programs.neovim = {
  #   enable = true;
  #   viAlias = true;
  #   vimAlias = true;
  #   vimdiffAlias = true;
  # };

  home.file.".Xresources" = {
    target = ".Xresources";
    text = ''
      Xft.antialias: true
      Xft.hinting:   true
      Xft.rgba:      rgb
      Xft.hintstyle: hintfull
      Xcursor.size: ${toString config.settings.cursorSize}
    '';
  };
  home.file.".Xmodmap" = {
    text = ''
      keycode 66 = Control_L
      clear Lock
    '';
  };
  home.file.".xinitrc".source = ./config/X/xinitrc;
  home.file.".xserverrc".source = ./config/X/xserverrc;
  home.file.".xsessionrc".source = ./config/X/xsessionrc;
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
  # home.activation.linkMyFiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   ln -s "${homeDirectory}/Documents" ~/Cloud/Documents
  #   ln -s "${homeDirectory}/Music " ~/Cloud/Music
  #   ln -s "${homeDirectory}/Pictures" ~/Cloud/Pictures
  # '';
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
  xdg.configFile."polybar/config".source = ./config/polybar-config.winfield;
  xdg.configFile."qutebrowser/config.py".source = ./config/qutebrowser/config.py;
  xdg.configFile."qutebrowser/quickmarks".source = /home/shaw/Documents/apps/qutebrowser/quickmarks;
  xdg.configFile."qutebrowser/bookmarks/urls".source = /home/shaw/Documents/apps/qutebrowser/bookmarks;
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
  # xdg.configFile."aerc/accounts.conf" = {
  #   source = ./personal/aerc/accounts.conf;
  # };
  xdg.configFile."cmus/rc".source = ./config/cmus.rc;
}
