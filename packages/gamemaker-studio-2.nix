{ stdenv, dpkg, glibc, gcc-unwrapped, autoPatchelfHook, pkgs, mypkgs }:
let

  # Please keep the version x.y.0.z and do not update to x.y.76.z because the
  # source of the latter disappears much faster.
  version = "2024.1400.4.1030";

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

  meta = with pkgs.lib; {
    description = "GameMaker Studio";
    homepage = https://gamemaker.io/en/;
    license = licenses.mit;
    maintainers = with pkgs.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "GameMaker";
  };
}
