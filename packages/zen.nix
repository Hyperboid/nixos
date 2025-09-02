# https://github.com/NixOS/nixpkgs/issues/327982#issuecomment-2684907720
{
  appimageTools,
  fetchurl,
  ...
}: let
  pname = "zen";
  version = "latest";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/latest/download/zen-x86_64.AppImage";
    sha256 = "sha256-kDXEhZIRAvd/36o3U2IA/XzmHsmuj2lMD0cpEd8YLL0=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      # Install .desktop file
      install -m 444 -D ${appimageContents}/zen.desktop $out/share/applications/${pname}.desktop
      # Install icon
      install -m 444 -D ${appimageContents}/zen.png $out/share/icons/hicolor/128x128/apps/${pname}.png
    '';

    meta = {
      platforms = ["x86_64-linux"];
    };
  }
