{ lib, stdenv, fetchFromGitHub
, pkg-config, wrapGAppsHook3
, glib, gcr, glib-networking, gsettings-desktop-schemas, gtk3, libsoup, webkitgtk
, xorg, findutils, gnused, coreutils, gst_all_1
}:
stdenv.mkDerivation rec {
  pname = "savoia";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Savoia";
    rev = "${version}";
    sha256 = "sha256-Fl4BisYLyHhwBimreTCA+gGwNgsY5/auOIN78uzRGRQ=";
  };

  nativeBuildInputs = [ pkg-config wrapGAppsHook3 ];
  buildInputs = [
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk3
    libsoup
    webkitgtk
  ] ++ (with gst_all_1; [
    # Audio & video support for webkitgtk WebView
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
  ]);

  sourceRoot = "source";

  buildPhase = ''
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp surf $out/bin/savoia
  '';
  
    # Add run-time dependencies to PATH. Append them to PATH so the user can
    # override the dependencies with their own PATH.
  preFixup = let
    depsPath = lib.makeBinPath [ xorg.xprop findutils gnused coreutils ];
  in ''
    gappsWrapperArgs+=(
      --suffix PATH : ${depsPath}
    )
  '';

  # postFixup = ''
  #   patchelf --add-needed ${xorg.libX11}/lib/libX11.so $out/bin/savoia
  #   patchelf --add-needed ${xorg.libXft}/lib/libXft.so $out/bin/savoia
  # '';

  meta = with lib; {
    description = "Savoia - browser";
    homepage = "https://surf.suckless.org/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
