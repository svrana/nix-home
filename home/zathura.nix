{ config, ... }:
let
  colors = config.settings.theme.withHashTag;
in
{
  programs.zathura = {
    enable = true;
    extraConfig = ''
      set notification-error-bg       "${colors.base02}"
      set notification-error-fg       "${colors.base08}"
      set notification-warning-bg     "${colors.base02}"
      set notification-warning-fg     "${colors.base08}"
      set notification-bg             "${colors.base02}"
      set notification-fg             "${colors.base0A}"

      set completion-group-bg         "${colors.base00}"
      set completion-group-fg         "${colors.base04}"
      set completion-bg               "${colors.base01}"
      set completion-fg               "${colors.base05}"
      set completion-highlight-bg     "${colors.base02}"
      set completion-highlight-fg     "${colors.base06}"

      set index-bg                    "${colors.base01}"
      set index-fg                    "${colors.base05}"
      set index-active-bg             "${colors.base02}"
      set index-active-fg             "${colors.base06}"

      set inputbar-bg                 "${colors.base02}"
      set inputbar-fg                 "${colors.base06}"

      set statusbar-bg                "${colors.base01}"
      set statusbar-fg                "${colors.base05}"

      set highlight-color             "${colors.base03}"
      set highlight-active-color      "${colors.base0D}"

      set default-bg                  "${colors.base01}"
      set default-fg                  "${colors.base05}"

      # Recolor book content's color
      set recolor                     true
      set recolor-lightcolor          "${colors.base01}"
      set recolor-darkcolor           "${colors.base05}"
  '';
  };
}
