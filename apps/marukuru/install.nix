{ stdenv, lib, fetchFromGitHub}:

stdenv.mkDerivation rec {
  pname = "marukuru";
  version = "1.1";

  src = fetchFromGitHub {
      owner = "WanderingPenwing";
      repo = "Marukuru";
      rev = "${version}";
      sha256 = "sha256-U4HA0lgBbsgspAR53uBNKle7EUkzGSJ4oTWsaNa5xds=";
    };

  buildPhase = ''
    make
  '';

  dontFixup = true;
  installPhase = ''
    mkdir -p $out/bin
    cp dmenu $out/bin/marukuru
  '';

  meta = with lib; {
    description = "dmenu-marukuru";
    homepage = "https://tools.suckless.org/dmenu/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
