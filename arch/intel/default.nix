{ pkgs, ... }:
{
  hardware.cpu.intel.updateMicrocode = true;

  hardware.opengl = {
    enable = true;
    extraPackages = [
      pkgs.intel-media-driver # LIBVA_DRIVER_NAME=iHD
    ];
  };
}
