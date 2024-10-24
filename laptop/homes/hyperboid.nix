{
  config,
  pkgs,
  ...
}: {
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    cursorTheme.name = "Adwaita";
    cursorTheme.package = pkgs.gnome.adwaita-icon-theme;
    iconTheme.name = "Adwaita";
    iconTheme.package = pkgs.gnome.adwaita-icon-theme;
    theme.name = "Adwaota";
  };
  home.stateVersion = "24.05";
  home.packages = with pkgs; [
    gamescope
  ];
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
