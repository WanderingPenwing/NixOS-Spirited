{ stdenv, lib, fetchurl, autoPatchelfHook, patchelf, xorg, gcc, gnumake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "dwm";
  version = "1.6.1";

  src = fetchurl {
    url = "https://github.com/WanderingPenwing/Pendragon/archive/refs/tags/${version}.tar.gz";
    hash = "sha256-HvnlaoNPmJ24pKaZgu+CvlKmBXBQBEgo2UP6d8hRfD4="; # Replace with the correct hash for the version
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

  sourceRoot = "Pendragon-${version}";

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dwm $out/bin/dwm

    # Create the session file
    mkdir -p $out/share/xsessions
    cat > $out/share/xsessions/dwm.desktop << EOF
    [Desktop Entry]
    Name=Pendragon
    Comment=Pendragon Window Manager
    Exec=$out/bin/dwm
    Type=Application
    EOF
  '';

  postFixup = ''
    patchelf --add-needed ${xorg.libX11}/lib/libX11.so $out/bin/dwm
    patchelf --add-needed ${xorg.libXft}/lib/libXft.so $out/bin/dwm
  '';

  meta = with lib; {
    description = "pendragon - dynamic windows manager";
    homepage = "https://dwm.suckless.org/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
