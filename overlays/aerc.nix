self: super:
{
  aerc = super.aerc.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./aerc.patch
    ];
  });
}
