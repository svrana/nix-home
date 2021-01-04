{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aws
  ];

  programs.bash.sessionVariables = {
    AWS_SHARED_CREDENTIALS_FILE = "$XDG_CONFIG_HOME/aws/credentials";
    AWS_CONFIG_FILE = "$XDG_CONFIG_HOME/aws/config";
  };
}
