{ pkgsUnstable, ... }:
{
  home.packages = with pkgsUnstable; [
    minikube
  ];

  # still leaves cruft in the home directory and causes other problems so meh
  # programs.bash.sessionVariables = {
  #   MINIKUBE_HOME = "$XDG_CONFIG_HOME/minikube";
  # };
}
