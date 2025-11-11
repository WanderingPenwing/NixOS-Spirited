{ lib, fetchFromGitHub, rustPlatform, pkg-config, openssl, ffmpeg, sqlite }:

rustPlatform.buildRustPackage rec {
  pname = "matui";
  version = "v0.5.0";

  src = fetchFromGitHub {
      owner = "pkulak";
      repo = "matui";
      rev = "${version}";
      sha256 = "sha256-RTHsyrFwRz2AveInzMz0nTEUDrplj6einqzyp0KX6kM=";
    };

  cargoLock = {
    lockFile = "${src}/Cargo.lock"; 
  };

  buildInputs = [
	openssl
	sqlite
  ];
  nativeBuildInputs = [
	pkg-config
    ffmpeg 
  ];

  meta = with lib; {
    description = "my status bar";
    homepage = "https://github.com/WanderingPenwing/Turnip";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

