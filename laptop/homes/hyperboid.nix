{
  config,
  pkgs,
  lib,
  specialArgs,
  ...
}: let
  unstable = specialArgs.unstable;
in {
  gtk = let
    icons = {
      name = "Adwaita";
      package = pkgs.gnome.adwaita-icon-theme;
    };
  in {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    cursorTheme = icons;
    iconTheme = icons;
    theme.name = "Adwaita";
  };
  home.stateVersion = "24.05";
  home.packages =
    (with pkgs; [
      gamescope
      blockbench
      bun
      unityhub
      vesktop
      aseprite
      nodejs-18_x
      cargo
      rustc
      rust-analyzer
      ffmpeg
      (callPackage ../../packages/zen.nix {})
    ])
    ++ (with unstable; [
      vscode
      tiled
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
