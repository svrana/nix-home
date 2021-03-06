{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aws-vault
  ];

  programs.bash.sessionVariables = {
    AWS_VAULT_BACKEND = "pass";
    AWS_VAULT_PASS_PREFIX = "vault";
    AWS_VAULT_PASS_PASSWORD_STORE_DIR = "$XDG_DATA_HOME/password-store";
  };
}
