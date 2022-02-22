final: prev:
{
  zoom-us = prev.zoom-us.overrideAttrs (old: {
    postFixup = old.postFixup + ''
      wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE --unset WAYLAND_DISPLAY
    '';
  });
  zoom = prev.zoom-us.overrideAttrs (old: {
    postFixup = old.postFixup + ''
      wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --unset WAYLAND_DISPLAY
    '';
  });
}
