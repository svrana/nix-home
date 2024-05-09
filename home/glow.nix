{ pkgs, ... }:
{
  home.packages = with pkgs; [
    glow
  ];

  home.shellAliases = {
    "glow" = "glow -p";
  };
}
