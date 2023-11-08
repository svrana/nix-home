{ pkgs, ... }:
{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      fish_vi_key_bindings

      source $RCS/fish/functions.fish
    '';
    shellAliases = {
      "cd.." = "cd ..";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../..";
      "cdd" = "cd $DOTFILES";

      "p" = "pushd";
      "P" = "popd";

      "v" = "nvim";
      "vir" = "nvim -R -";
      "r" = "ranger";
      "pl" = "pulumi";

      "cat" = "${pkgs.bat}/bin/bat";
      "lsd" = "ls -d */";
      "g" = "git";

      "sctl" = "systemctl";
      "jctl" = "journalctl";
      "nctl" = "networkctl";

      "make" = "make -j$(nproc)";

      "av" = "aws-vault";
    };
  };
}

