{ stdenv, lib, fetchFromGitHub, glib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "turnip";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Turnip";
    rev = "${version}";
    sha256 = "sha256-Dg+RZXkcgvH4txcWOW6e7Kdb5VJgwZhWil0a3Z7HhCM=";
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
