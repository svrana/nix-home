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

    ./programs/go.nix
    ./programs/dircolors
    ./programs/direnv
    ./programs/k9s
    ./programs/tmux
    ./programs/git.nix
    ./programs/fzf.nix
    ./programs/ssh.nix

    ./programs/bash.nix
  ];

  home.packages = with pkgs; [
    aerc
    autocutsel
    dbeaver
    #dircolors
    fd
    firefox
    jq
    kubectl
    kubectx
    packer
    pass
    ripgrep
    wmctrl
  ];

  # home.activation.linkMyFiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
  # ln -s "${home_directory}/Downloads" ~/.dl
# '';
}
