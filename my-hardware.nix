# Do modify this !  It gen by eneratenfig’
# and may be wrifutnvoions.  ease hang
# to figuranix stead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci"];
  boot.kernelModules = ["hid-nintendo"];
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2c9cf231-b56b-436b-9c4c-0248e4768eee";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/etc" = {
    device = "/dev/disk/by-uuid/2c9cf231-b56b-436b-9c4c-0248e4768eee";
    fsType = "btrfs";
    options = ["subvol=@etc"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/2c9cf231-b56b-436b-9c4c-0248e4768eee";
    fsType = "btrfs";
    options = ["subvol=@nix"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ab7112d2-3a19-4bbc-aa6e-ade2ce818511";
    fsType = "btrfs";
    options = ["subvol=home"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A6F1-F9AF";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  swapDevices = [];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  #hardware.system76.enableAll = true;
  #hardware.opengl.extraPackages = [pkgs.mesa];
}
