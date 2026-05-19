
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
      url = "https://piston-data.mojang.com/v1/objects/63a80c132f2270af2f43161db596fce69e3e5339/server.jar";
      sha1 = "759kx7p6zjbba78n8cpsyw125w9hra33";
      jre_headless = pkgs.jdk25_headless;
    };
  };
}
