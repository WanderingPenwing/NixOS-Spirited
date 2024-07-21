{ stdenv, lib, fetchurl, autoPatchelfHook, patchelf, xorg, gcc, gnumake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "kodama";
  version = "1.1.1";

  src = fetchurl {
    url = "https://github.com/WanderingPenwing/Kodama/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-y6xyR6rkCl3WieKCgkys99AEdDW0LQvkbN8XK6T4HXQ="; # Replace with the correct hash for the version
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

  sourceRoot = "Kodama-${version}";
  
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
