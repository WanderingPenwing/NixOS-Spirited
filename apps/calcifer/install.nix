{
  stdenv,
  lib,
  fetchurl,
  libxkbcommon,
  patchelf,
  autoPatchelfHook,
  glib,
  libGL,
  libGLU,
  atk,
  gdk-pixbuf,
  webkitgtk,
  gtk3-x11,
}:
stdenv.mkDerivation rec {
  pname = "calcifer";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/WanderingPenwing/Calcifer/releases/download/${version}/calcifer-v${version}.tar.gz";
    hash = "sha256-/Q174J3WadatO4d1LuuMjIBphx1vaGnOSrZe/W+08KA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    glib
    libGL
    libGLU
    atk
    gdk-pixbuf
    webkitgtk
    gtk3-x11
  ];

  buildInputs = [
    libxkbcommon
    patchelf
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D calcifer $out/bin/calcifer
    runHook postInstall
  '';

  # lib.optionalString (!stdenv.isDarwin)
  postFixup = ''
    patchelf --add-needed ${libxkbcommon}/lib/libxkbcommon-x11.so  $out/bin/calcifer
    patchelf --add-needed ${libGL}/lib/libGL.so  $out/bin/calcifer
    patchelf --add-needed ${libGLU}/lib/libGLU.so  $out/bin/calcifer
  '';

  meta = with lib; {
    description = "My Fiery IDE";
    homepage = "https://github.com/WanderingPenwing/Calcifer";
  };
}
