final: prev: rec {
  powerline-go = prev.powerline-go.overrideAttrs (old: {
    src = final.fetchFromGitHub {
      owner = "svrana";
      repo = "powerline-go";
      rev = "6645ee9525c377e35b8aa6968e22e539883c16ab";
      sha256 = "0i357gpbrd4sf45nhd8pn0c239idfrx0x59hcnr93ah59j28svi8";
    };
  });
}
