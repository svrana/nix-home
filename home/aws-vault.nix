{ pkgs, ... }:
{
  home.packages = with pkgs; [
    aws-vault
  ];

  home.sessionVariables = {
    AWS_VAULT_BACKEND = "pass";
    AWS_VAULT_PASS_CMD = "gopass";
    AWS_VAULT_PASS_PREFIX = "vault";
    AWS_VAULT_PASS_PASSWORD_STORE_DIR = "$HOME/.local/share/password-store";
  };

  programs.bash.shellAliases = {
      "av" = "aws-vault";
  };
}
