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
  pname = "Calcifer";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/WanderingPenwing/Calcifer/releases/download/${version}/calcifer_v${version}.tar.gz";
    hash = "sha256-27svjp/ju5uF4wNx9HmnTSjAxt6dF/TxjZDGMHwY9xw=";
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
    description = "workflow test";
    homepage = "https://github.com/WanderingPenwing/flow";
  };
}
