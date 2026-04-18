{
  stdenv,
  dpkg,
  glibc,
  gcc-unwrapped,
  autoPatchelfHook,
  buildFHSEnv,
  pkgs,
  mypkgs,
  ...
}:
let

  # Please keep the version x.y.0.z and do not update to x.y.76.z because the
  # source of the latter disappears much faster.
  version = "2024.1400.4.1030";
  fhsPackages = (pkgs: with pkgs; [
    glibc

    # dotnet
    curl
    icu
    libunwind
    libuuid
    lttng-ust
    openssl
    zlib

    sdl3
    SDL2
    SDL
    # mono
    krb5

    # Needed for headless browser-in-vscode based plugins such as
    # anything based on Puppeteer https://pptr.dev .
    # e.g. Roo Code
    glib
    nspr
    nss
    dbus
    at-spi2-atk
    cups
    expat
    libxkbcommon
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libxcb
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    cairo
    pango
    alsa-lib
    libgbm
    udev
    libudev0-shim
  ]);
  fhs = buildFHSEnv {
    pname = "gamemaker-studio-2";
    inherit version;
    targetPkgs = fhsPackages;

    extraBwrapArgs = [
      "--bind-try /etc/nixos/ /etc/nixos/"
      "--ro-bind-try /etc/xdg/ /etc/xdg/"
    ];
    extraInstallCommands = ''
    '';
    runScript = "${(mypkgs.gamemaker-studio-2-unwrapped)}/opt/GameMaker-Beta/GameMaker";
  };
  fhsLanguageServer = buildFHSEnv {
    pname = "GameMakerLanguageServer";
    inherit version;
    targetPkgs = fhsPackages;

    extraBwrapArgs = [
      "--bind-try /etc/nixos/ /etc/nixos/"
      "--ro-bind-try /etc/xdg/ /etc/xdg/"
    ];
    extraInstallCommands = ''
    '';
    runScript = "${(mypkgs.gamemaker-studio-2-unwrapped)}/opt/GameMaker-Beta/x86_64/GameMakerLanguageServer";
  };

in stdenv.mkDerivation {
  name = "gamemaker-${version}";

  system = "x86_64-linux";

  src = pkgs.writeShellScriptBin "GameMaker" ''
    exec ${(mypkgs.gamemaker-studio-2-unwrapped)}/opt/GameMaker-Beta/GameMaker "$@"
  '';

  # Required for compilation
  nativeBuildInputs = [
  ];

  # Required at running time
  buildInputs = with pkgs; [
  ];

  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    cp -r $src $out
    mkdir -p $out/bin
  '';

  passthru = {
    fhs = fhs;
    langserver = fhsLanguageServer;
  };

  meta = with pkgs.lib; {
    description = "GameMaker Studio";
    homepage = https://gamemaker.io/en/;
    license = licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "GameMaker";
  };
}
