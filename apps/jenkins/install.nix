{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, patchelf, xorg, gcc, gnumake, pkg-config, fontconfig, freetype, imlib2, libexif }:

stdenv.mkDerivation rec {
  pname = "dwm";
  version = "1.9.9a";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "dwm-Jenkins";
    rev = "${version}";
    sha256 = "sha256-qU4Tp7KP7MCnGeJmqjPodHerO/vWjRcxblUrYJk2ZUw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    gnumake
    gcc
    pkg-config
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXft
    xorg.libXinerama
    xorg.libXext
    fontconfig
    freetype
    imlib2
    libexif
  ];

  sourceRoot = "source";

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dwm $out/bin/dwm
  '';

  postFixup = ''
    patchelf --add-needed ${xorg.libX11}/lib/libX11.so $out/bin/dwm
    patchelf --add-needed ${xorg.libXft}/lib/libXft.so $out/bin/dwm
  '';

  meta = with lib; {
    description = "dynamic windows manager";
    homepage = "https://dwm.suckless.org/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
