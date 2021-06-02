{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
  ];
  programs.bash.sessionVariables = {
      KUBECONFIG = "$XDG_CONFIG_HOME/kube/config";
  };
  programs.bash.initExtra = ''
      source ${pkgs.kubectl}/share/bash-completion/completions/kubectl.bash
      complete -F __start_kubectl k
  '';
  programs.bash.shellAliases = {
      "k" = "kubectl";
  };
}
