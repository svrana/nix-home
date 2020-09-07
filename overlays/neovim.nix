self: super:
{
  neovim-unwrapped = super.neovim-unwrapped.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "neovim";
      repo = "neovim";
      rev = "4ed5204bc9d5811cd45209476ac1b9e2c2b74146";
      sha256 = "0cainyqcar7y2y4xaxps3wmpih10d4i2pk5yiwds64qp63nb34i0";
    };
  });
}

