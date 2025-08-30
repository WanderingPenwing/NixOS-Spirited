{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, ffmpeg, sqlite }:

rustPlatform.buildRustPackage rec {
  pname = "matui";
  version = "v0.5.0";

  src = fetchFromGitHub {
      owner = "pkulak";
      repo = "matui";
      rev = "${version}";
      sha256 = "sha256-U4HA0lgBbsgspAR53uBNKle7EUkzGSJ4oTWsaNa5xds=";
    };

  cargoLock = {
    lockFile = "${src}/Cargo.lock"; 
  };

  buildInputs = [
	openssl
  ];
  nativeBuildInputs = [
	pkg-config
    ffmpeg 
	sqlite
  ];

  meta = with lib; {
    description = "my status bar";
    homepage = "https://github.com/WanderingPenwing/Turnip";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

