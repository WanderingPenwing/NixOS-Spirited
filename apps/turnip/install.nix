{ stdenv, lib, fetchFromGitHub, glib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "turnip";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Turnip";
    rev = "${version}";
    sha256 = "sha256-HyhbCnZFrGMkS/OsZM6vqkLBE7RPKIegSR1fB7AfGgA=";
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
