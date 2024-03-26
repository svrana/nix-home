{ ... }:
{
  programs.bash.initExtra = ''
    export CDP_DIR_SPEC="$PROJECTS:2;$PROJECTS/aws-infra:6"
    export CDP_DEFAULT_VAR="GRUF_PROJECT"
    export CDP_PROJECT_VAR="PROJECTS"
    source "$PROJECTS/cdp/cdp.sh"
  '';
}
