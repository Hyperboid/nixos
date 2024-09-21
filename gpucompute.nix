{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    custom.gpu_compute_enable = pkgs.lib.mkOption {
      default = false;
      type = pkgs.lib.types.bool;
      description = "Enable apps and services that require GPU compute.";
    };
  };
  config = {
    services.ollama = lib.mkIf config.custom.gpu_compute_enable {
      enable = true;
      models = "/mnt/ollama/models";
      acceleration = null;
      writablePaths = ["/mnt/ollama"];
      home = "/mnt/ollama";
    };
    environment.systemPackages = lib.mkIf config.custom.gpu_compute_enable [pkgs.blender];
    # Use Nvidia driver if compute apps are enabled
    hardware.nvidia.package =
      lib.mkIf config.custom.gpu_compute_enable
      config.boot.kernelPackages.nvidiaPackages.stable;
  };
}
