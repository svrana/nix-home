{ pkgs, ... }:
{
  home.packages = with pkgs; [
    glow
  ];

  programs.bash.shellAliases = {
    "glow" = "glow -p";
  };
}
