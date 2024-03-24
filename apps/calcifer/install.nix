{
  stdenv,
  lib,
  fetchurl,
  libxkbcommon,
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
