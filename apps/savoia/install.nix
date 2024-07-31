{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, patchelf, xorg, gcc, glib, gnumake, pkg-config, gst_all_1, libxcrypt, fontconfig, freetype, imlib2, webkitgtk, glib-networking }:

stdenv.mkDerivation rec {
  pname = "savoia";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Savoia";
    rev = "${version}";
    sha256 = "sha256-974TViU+Wso8KaI4RuoFzqaIoZ9pCfhPt1CPy27nyRY=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    gnumake
    gcc
    pkg-config
  ];

  buildInputs = [
    glib
    xorg.libX11
    xorg.libXft
    xorg.libXrandr
    xorg.libXinerama
    xorg.libXext
    libxcrypt
    fontconfig
    freetype
    imlib2
    webkitgtk
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  sourceRoot = "source";

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp surf $out/bin/savoia-core
    # Create a wrapper script
    cat > $out/bin/savoia <<EOF
    #!/usr/bin/env bash
    export GIO_EXTRA_MODULES=${glib-networking}/lib/gio/modules
    exec $out/bin/savoia-core "\$@"
    EOF
    chmod +x $out/bin/savoia
  '';

  postFixup = ''
    patchelf --add-needed ${xorg.libX11}/lib/libX11.so $out/bin/savoia-core
    patchelf --add-needed ${xorg.libXft}/lib/libXft.so $out/bin/savoia-core
  '';

  meta = with lib; {
    description = "Savoia - browser";
    homepage = "https://surf.suckless.org/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
