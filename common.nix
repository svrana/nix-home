{ config, pkgs, ... }:

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
    # SHAW: neovim
    ./programs/tmux
    ./programs/git.nix
    ./programs/fzf.nix
    ./programs/ssh.nix

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
    ripgrep
    shellcheck
    ssh-agents
    wmctrl
  ];

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

  home.file.".inputrc".source = ./config/inputrc;
  home.file.".local/bin" = {
    source = ./scripts;
    recursive = true;
  };
  home.file.".rvmrc".text = ''
    rvm_autoupdate_flag=2
    export rvm_max_time_flag=20
    create_on_use_flag=1
    rvm_silence_path_mismatch_check_flag=1
  '';
  # home.activation.linkMyFiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
  #   ln -s "${home_directory}/Documents" ~/Cloud/Documents
  #   ln -s "${home_directory}/Music " ~/Cloud/Music
  #   ln -s "${home_directory}/Pictures" ~/Cloud/Pictures
  # '';
  xdg.configFile."mimeapps.list".source = ./config/mimeapps.list;
}