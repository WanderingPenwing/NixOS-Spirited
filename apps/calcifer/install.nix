{ stdenv, lib, fetchFromGitHub, autoPatchelfHook,
  libxkbcommon, libGL, libGLU, atk, gdk-pixbuf, webkitgtk, gtk3-x11, glib,
  libxcb, libXcursor, libXrandr, libXi, pkg-config, xorg, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "calcifer";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Calcifer";
    rev = "${version}";
    sha256 = "sha256-SsXXwfenkbG0pePKfGWkrxAbsPX3/LYfXSVFFUVbE7o=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock"; 
  };

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = [
    libxcb
    libXcursor
    libXrandr
    libXi
    atk
    gdk-pixbuf
    webkitgtk
    glib
    libGL
    libGLU
    libxkbcommon
    gtk3-x11
    xorg.libX11
  ];

  postFixup = ''
    patchelf --add-needed ${libxkbcommon}/lib/libxkbcommon-x11.so $out/bin/calcifer
    patchelf --add-needed ${libGL}/lib/libGL.so $out/bin/calcifer
    patchelf --add-needed ${libGLU}/lib/libGLU.so $out/bin/calcifer
  '';

  meta = with lib; {
    description = "code editor";
    homepage = "https://github.com/WanderingPenwing/Calcifer";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
