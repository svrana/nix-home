{ pkgs, ... }:
{
  home.packages = with pkgs; [
    autotiling
    dante
    dbeaver
    discord
    diffstat
    docker-compose
    emacs
    eza
    networkmanager_dmenu
    cachix
    ctlptl
    google-chrome
    gh
    element-desktop # matrix client
    entr
    evince
    gimp
    gnupg
    kind
    pkgs.kubernetes-helm
    gitAndTools.hub
    grpcurl
    kubectx
    ledger-live-desktop
    i3-ratiosplit # works for sway too
    imv
    libsixel # for img2sixel
    maim # screenshot
    mpv
    gnome.nautilus
    gnome.eog
    libreoffice
    nixfmt
    nixpkgs-review
    #packer
    pulumi-bin
    prototool
    python3
    readline
    rnix-lsp
    shellcheck
    shfmt
    spotify-tui
    slack
    ssh-agents
    standardnotes
    system-san-francisco-font
    sysz
    tdesktop # telegram
    tilt
    tealdeer
    tmuxinator
    tree
    w3m
    wmctrl
    xdg-utils
    zoom
    yarn
    bc
    vanilla-dmz
    yq
    buf
    #go-migrate
    nodejs
    typescript
    #postman
    protoc-gen-validate
    #cilium-cli
    #certbot
    #istioctl
    luakit

    #obs-studio
    #psst

    # sway/wayland specific
    avizo
    clipman
    swaylock
    swayidle
    wl-clipboard
    wf-recorder # i.e., wf-recorder -g "$(slurp)"
    swaybg
    waybar
    wtype
    slurp
    grim
    brightnessctl
  ];
}
