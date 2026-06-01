
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
      url = "https://piston-data.mojang.com/v1/objects/b7c0d39bf9d7897dba2f9f725957224e74d89a0f/server.jar";
      sha1 = "1yddhx2f49bmjwlz5yx7v2fpz6dx7h5p";
      jre_headless = pkgs.jdk25_headless;
    };
  };
  users.users.minecraft = {
    extraGroups = ["systemd-journal"];
    packages = with pkgs; [
      tmux
    ];
    shell = pkgs.zsh;
  };
}
