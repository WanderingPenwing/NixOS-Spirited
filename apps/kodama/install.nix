{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, xorg, gcc, gnumake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "kodama";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Kodama";
    rev = "${version}";
    sha256 = "sha256-TOcoyb7n7MI/+oalNkcrUVPLJlrtvCh7e34Pv0KltBs=";
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
    cp st $out/bin/kodama
  '';

  # Optional post-fixup to handle dynamic linking
  postFixup = ''
    patchelf --add-needed ${xorg.libX11}/lib/libX11.so $out/bin/kodama
    patchelf --add-needed ${xorg.libXft}/lib/libXft.so $out/bin/kodama
  '';

  meta = with lib; {
    description = "kodama - simple terminal";
    homepage = "https://st.suckless.org/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
