{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}: let
  unstable = specialArgs.unstable;
in {
  options = {
    custom.gpu_compute_enable = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = "Enable apps and services that require GPU compute.";
    };
    custom.nvidia_proprietary_drivers = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = "Enable nvidia's GPU driver instead of the default one";
    };
  };
  config = {
    environment.systemPackages = lib.mkIf config.custom.gpu_compute_enable [specialArgs.pkgs2411.blender];
    # Use Nvidia driver if compute apps are enabled
    # Adapted from https://nixos.wiki/wiki/Nvidia
    hardware.nvidia = lib.mkIf config.custom.nvidia_proprietary_drivers {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        # Make sure to use the correct Bus ID values for your system!
        intelBusId = lib.mkOverride 1001 "PCI:0:2:0";
        nvidiaBusId = lib.mkOverride 1001 "PCI:1:0:0";
        # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
      };
    };
  };
}
