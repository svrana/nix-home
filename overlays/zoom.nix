self: super:
{
  zoom-us = super.zoom-us.overrideAttrs (old: {
    postFixup = old.postFixup + ''
      wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE --unset WAYLAND_DISPLAY
    '';
  });
  zoom = super.zoom-us.overrideAttrs (old: {
    postFixup = old.postFixup + ''
      wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --unset WAYLAND_DISPLAY
    '';
  });
}
