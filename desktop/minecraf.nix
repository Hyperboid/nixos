
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  services.minecraft-server = {
    enable = true;
    dataDir = "/opt/minecraf";
    eula = true;
    openFirewall = true;
    package = pkgs.minecraft-server.override {
      url = "https://piston-data.mojang.com/v1/objects/823e2250d24b3ddac457a60c92a6a941943fcd6a/server.jar";
      sha1 = "db6kz521m6k94356az2dlgabs9824gl2";
      jre_headless = pkgs.jdk25_headless;
    };
  };
  users.users.hyperboid.extraGroups = [ "minecraft" ];
  users.users.minecraft = {
    extraGroups = ["systemd-journal"];
    packages = with pkgs; [
      tmux
    ];
    shell = pkgs.zsh;
    homeMode = "750";
  };
}
