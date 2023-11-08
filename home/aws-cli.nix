{ pkgs, ... }:
{
  home.packages = with pkgs; [
    awscli2
  ];

  home.sessionVariables = {
    AWS_SHARED_CREDENTIALS_FILE = "$HOME/.config/aws/credentials";
    AWS_CONFIG_FILE = "$HOME/.config/aws/config";
  };
}
