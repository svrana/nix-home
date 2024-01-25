final: prev: {
  standardnotes = let
    pname = "standardnotes";
    version = "3.183.22";
    src = prev.fetchurl {
      url = "https://github.com/standardnotes/app/releases/download/%40standardnotes%2Fdesktop%403.183.22/standard-notes-3.183.22-linux-x86_64.AppImage";
      hash = "sha256-tPbTgM13+c+wyhCAPawr3U71ofIHFN96x8QYes7RhfE=";
    };
    appimageContents = prev.appimageTools.extract { inherit pname version src; };
  in prev.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs = pkgs: [ pkgs.libsecret ];

    extraInstallCommands = ''
      chmod -R +w $out
      mv $out/bin/${pname}-${version} $out/bin/${pname}

      ${prev.desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
        --set-key Exec --set-value ${pname} ${appimageContents}/standard-notes.desktop
      ln -s ${appimageContents}/usr/share/icons $out/share
    '';
  };
}
