{ pkgsUnstable, ... }:
{
  home.packages = with pkgsUnstable; [
    minikube
  ];

  programs.bash.sessionVariables = {
    MINIKUBE_HOME = "$XDG_CONFIG_HOME/minikube";
  };
}
