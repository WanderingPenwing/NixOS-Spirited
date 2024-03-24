{
  stdenv,
  lib,
  fetchurl,
  libxkbcommon,
  autoPatchelfHook,
}:
stdenv.mkDerivation rec {
  pname = "calcifer";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/WanderingPenwing/Calcifer/releases/download/${version}/calcifer-v${version}.tar.gz";
    hash = "fd0d7be09dd669d6ad3b87752eeb8c8c8069871d6f6869ce4ab65efd6fb4f0a0";
  };

  nativeBuildInputs = [
    ${version}
    autoPatchelfHook
  ];

  buildInputs = [
    libxkbcommon
  ];
  # echo 'export LD_LIBRARY_PATH=/run/opengl-driver/lib/:${pkgs.lib.makeLibraryPath [pkgs.libxkbcommon]}' > $out/etc/profile.d/calcifer_ld_library_path.sh

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D calcifer $out/bin/calcifer
    runHook postInstall
  '';

  meta = with lib; {
    description = "My Fiery IDE";
    homepage = "https://github.com/WanderingPenwing/Calcifer";
  };
}
