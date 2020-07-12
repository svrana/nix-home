{ pkgs, lib, ... }:

{
  programs.bat = {
    enable = true;
    config = {
      theme = "Solarized (dark)";
      style = "changes";
    };
  };
}
