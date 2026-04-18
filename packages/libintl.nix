{ stdenv, dpkg, glibc, gcc-unwrapped, autoPatchelfHook, pkgs }:
let

  # Please keep the version x.y.0.z and do not update to x.y.76.z because the
  # source of the latter disappears much faster.
  version = "8";

  src = pkgs.gettext;

in stdenv.mkDerivation {
  name = "sketchy-ass-libintl";

  system = "x86_64-linux";

  inherit src;

  # Required for compilation
  nativeBuildInputs = [];

  # Required at running time
  buildInputs = with pkgs; [
    glibc
    gcc-unwrapped
  ];

  unpackPhase = "true";

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out/lib
    cp $src/lib/preloadable_libintl.so $out/lib/libintl.so.8
  '';

  meta = with pkgs.lib; {
    description = "GameMaker Studio";
    homepage = https://gamemaker.io/en/;
    license = licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
  mainProgram = "GameMaker";
}