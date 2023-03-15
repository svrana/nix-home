{ pkgs, lib, home, ... }:
let
  helm-plugins-dir = pkgs.symlinkJoin {
    name = "helm-plugins";
    paths = with pkgs.kubernetes-helmPlugins; [
      helm-diff
      helm-secrets
    ];
  };
in
{
  programs.bash.initExtra = ''
    export HELM_PLUGINS="${helm-plugins-dir}"
  '';

  home.packages = [
    pkgs.kubernetes-helm
    pkgs.helmfile
  ];
}
