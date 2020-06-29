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

  nixpkgs.config.allowUnfree = true;

  imports = [
    ./direnv.nix
    ./tmux.nix
    ./git.nix
    ./fzf.nix
    ./bash.nix
  ];

  home.packages = with pkgs; [
    aerc
    dbeaver
    fd
    firefox
    jq
    k9s
    kubectl
    kubectx
    packer
    pass
    ripgrep
    wmctrl
  ];
}
