
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
      url = "https://piston-data.mojang.com/v1/objects/7229ab459c87c919034db33b6fc9ee7367a0bd97/server.jar";
      sha1 = "jyys0rvkxv4nyfxk9l1ikjc7ki2snabj";
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
