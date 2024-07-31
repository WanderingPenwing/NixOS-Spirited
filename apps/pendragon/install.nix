{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, patchelf, xorg, gcc, gnumake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "dwm";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Pendragon";
    rev = "${version}";
    sha256 = "sha256-M6y0CXRI6RdlSDcKXRbUOGN+XIjo+rADHG9hFwQIcO0=";
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
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXext
    xorg.libXpm
    xorg.libXmu
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
