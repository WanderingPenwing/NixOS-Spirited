{ stdenv, lib, fetchFromGitHub, glib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "turnip";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Turnip";
    rev = "${version}";
    sha256 = "sha256-MNMxv0O/6x/4aQN3pjvbng/1X3ebAPPO9XqlgBXxrUE=";
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
