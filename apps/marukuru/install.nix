{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, patchelf, xorg, gcc, gnumake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "marukuru";
  version = "1.1";

  src = fetchFromGitHub {
      owner = "WanderingPenwing";
      repo = "Marukuru";
      rev = "${version}";
      sha256 = "sha256-U4HA0lgBbsgspAR53uBNKle7EUkzGSJ4oTWsaNa5xds=";
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
    cp dmenu $out/bin/marukuru
  '';

  # # Optional post-fixup to handle dynamic linking
  # postFixup = ''
  #   patchelf --add-needed ${xorg.libX11}/lib/libX11.so $out/bin/marukuru
  #   patchelf --add-needed ${xorg.libXft}/lib/libXft.so $out/bin/marukuru
  # '';

  meta = with lib; {
    description = "dmenu";
    homepage = "https://tools.suckless.org/dmenu/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
