{ stdenv, lib, fetchFromGitHub, glib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "turnip";
  version = "1.7";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Turnip";
    rev = "${version}";
    sha256 = "sha256-t4NQ4wDpLCdxJUnEzG+/LP/KPejoUqRxtxptwbMjJGE=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock"; 
  };

  nativeBuildInputs = [
    glib
  ];

  meta = with lib; {
    description = "my status bar";
    homepage = "https://github.com/WanderingPenwing/Turnip";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
