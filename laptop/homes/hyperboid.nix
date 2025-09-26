{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}: let
  unstable = specialArgs.unstable;
  mypkgs = specialArgs.mypkgs;
in {
  gtk = let
    icons = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  in {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    cursorTheme = icons;
    iconTheme = icons;
    theme.name = "Adwaita";
  };
  home.stateVersion = "24.05";
  # Manual file deployment
  home.file = {
    "${config.xdg.configHome}/niri" = {
      source = ./hyperboid/niri;
      recursive = true;
    };
  };
  home.packages =
    (with pkgs; [
      gamescope
      blockbench
      bun
      unityhub
      vesktop
      aseprite
      nodejs
      cargo
      rustc
      rust-analyzer
      ffmpeg
      fuzzel # app launcher used in niri config
      waybar
      xwayland-satellite # used by niri to support xwayland
      pavucontrol
      mypkgs.zen
    ])
    ++ (with unstable; [
      vscode
      tiled
      dragon-drop
      swaynotificationcenter
    ]);
  services = {
    arrpc = {
      enable = true;
    };
  };
  programs = {
    emacs = {
      enable = true;
    };
    gnome-shell = {
      enable = false;
      extensions = with pkgs.gnomeExtensions; [
        {package = paperwm;}
        {package = appindicator;}
        {package = upower-battery;}
        {package = battery-usage-wattmeter;}
        {package = ddterm;}
      ];
    };
  };
}
