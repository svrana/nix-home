self: super:
{
  zoom = super.zoom-us.overrideAttrs (old: {
    postFixup = old.postFixup + ''
      wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --unset WAYLAND_DISPLAY
    '';
  });

  discord = super.discord.overrideAttrs (old: {
    src = builtins.fetchTarball https://discord.com/api/download?platform=linux&format=tar.gz;
  });
}
