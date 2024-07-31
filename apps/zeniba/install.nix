{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, patchelf, xorg, gcc, gnumake, pkg-config, imlib2, libexif }:

stdenv.mkDerivation rec {
  pname = "zeniba";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Zeniba";
    rev = "${version}";
    sha256 = "sha256-xnm+Y6f3Xm34KtbM5YD1CD5N6nF/M0C5jie30lNmWes=";
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
    imlib2
    libexif
  ];

  sourceRoot = "source";

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp nsxiv $out/bin/zeniba
    
    mkdir -p $out/share/applications
    cat > $out/share/applications/zeniba.desktop <<EOF
    [Desktop Entry]
    Name=Zeniba
    Exec=$out/bin/zeniba %F
    Type=Application
    MimeType=image/bmp;image/gif;image/jpeg;image/jpg;image/png;image/tiff;image/x-bmp;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-tga;image/x-xpixmap;image/webp;image/heic;image/svg+xml;application/postscript;image/jp2;image/jxl;image/avif;image/heif;
    NoDisplay=true
    EOF
  '';

  postFixup = ''
    patchelf --add-needed ${xorg.libX11}/lib/libX11.so $out/bin/zeniba
    patchelf --add-needed ${xorg.libXft}/lib/libXft.so $out/bin/zeniba
  '';

  meta = with lib; {
    description = "nsxiv - image viewer";
    homepage = "https://nsxiv.codeberg.page/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
