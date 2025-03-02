# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking.hostName = "hyperboid-schmesktop"; # Define your hostname.
  programs.steam.enable = lib.mkForce false;
  boot.loader.grub.device = lib.mkForce "/dev/sda";
  boot.loader.grub.efiSupport = lib.mkForce false;
}
