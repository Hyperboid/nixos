
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
      url = "https://piston-data.mojang.com/v1/objects/6cd1e711f62dc45497df6f390a9e83ba6191be41/server.jar";
      sha1 = "86z92qdshfg0lfbgvybm9i1dyq8yglbc";
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
