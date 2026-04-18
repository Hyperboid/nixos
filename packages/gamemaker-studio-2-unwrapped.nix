{ stdenv, dpkg, glibc, gcc-unwrapped, autoPatchelfHook, pkgs }:
let

  # Please keep the version x.y.0.z and do not update to x.y.76.z because the
  # source of the latter disappears much faster.
  version = "2024.1400.4.1030";

  src = pkgs.fetchurl {
    # Link retrieved from https://gamemaker.io/en/download. For some reason, this link changes when you click it.
    url = "https://download.opr.gg/GameMaker-Beta-${version}.deb";
    sha256 = "sha256-RWnQnG5Pe4FSMdIt/znUoT9jmTuhCm36wcNB5JXQPDI=";
  };

in stdenv.mkDerivation {
  name = "gamemaker-${version}-unwrapped";

  system = "x86_64-linux";

  inherit src;

  # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
    dpkg
  ];

  # Required at running time
  buildInputs = with pkgs; [
    glibc
    gcc-unwrapped
    libz
    lttng-ust_2_12
    libxml2
    musl
    libpng
    brotli
    bzip2
    gettext
    openssl
    dotnetCorePackages.dotnet_10.runtime
    (pkgs.callPackage ./libintl.nix {})
    (pkgs.callPackage ./support/libxml-2-2.nix {})
  ];

  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    # cp -av $out/usr/* $out
    # cp -av $out/opt/GameMaker-Beta* $out/bin
    # rm -rf $out/opt
  '';

  meta = with pkgs.lib; {
    description = "GameMaker Studio";
    homepage = https://gamemaker.io/en/;
    license = licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "GameMaker";
  };
}
