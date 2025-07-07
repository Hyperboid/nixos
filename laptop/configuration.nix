# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}: let
  unstable = specialArgs.unstable;
  gnomeExts = with pkgs.gnomeExtensions; [
    ddterm
    paperwm
    appindicator
    upower-battery
    battery-usage-wattmeter
    battery-health-charging
  ];
in {
  imports = [
    # Include the results of the hardware scan.
    ./my-hardware.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.grub.extraEntries = ''
    # GRUB 2 with UEFI example, chainloading another distro
    menuentry "DRCbian - Wii U Gamepad" {
      set root=(hd1,2)
      chainloader /EFI/debian/grubx64.efi
    }
  '';

  networking.hostName = "hyperboid-laptop"; # Define your hostname.
  # Whether or not to use CUDA.
  custom.gpu_compute_enable = true;
  custom.nvidia_proprietary_drivers = true;
  # If travelling, set a timezone override.
  # time.timeZone = lib.mkForce "Europe/Lisbon";
}
