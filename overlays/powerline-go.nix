self: super:
{
  powerline-go = super.powerline-go.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "svrana";
      repo = "powerline-go";
      rev = "6c70514d7c69129df50603242674459e04a06f46";
      sha256 = "1qgap9f0q9lswm7rnfi6r0wxq4myqzbnd76y4ni4ga6q4a77grny";
    };
  });
}
