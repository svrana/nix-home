{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
  ];
  programs.bash.initExtra = ''
      source ${pkgs.kubectl}/share/bash-completion/completions/kubectl.bash
      complete -F __start_kubectl k
  '';
  home.shellAliases = {
      "k" = "kubectl";
  };
}
