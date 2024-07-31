{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, rustc,
  libxkbcommon, libGL, libGLU, atk, gdk-pixbuf, webkitgtk, gtk3-x11, glib,
  libxcb, libXcursor, libXrandr, libXi, pkg-config, xorg, gnome, cargo, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "jiji";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Jiji";
    rev = "${version}";
    sha256 = "sha256-ml7jYqdPvnUlSFBoB2KUi37CHXIZCLnHk5ofYslqAKk=";
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
    rustc
    cargo
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

  # lib.optionalString (!stdenv.isDarwin)
  postFixup = ''
    patchelf --add-needed ${libxkbcommon}/lib/libxkbcommon-x11.so  $out/bin/jiji
    patchelf --add-needed ${libGL}/lib/libGL.so  $out/bin/jiji
    patchelf --add-needed ${libGLU}/lib/libGLU.so  $out/bin/jiji
  '';

  meta = with lib; {
    description = "light discord alternative";
    homepage = "https://github.com/WanderingPenwing/Jiji";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
