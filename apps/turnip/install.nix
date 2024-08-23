{ stdenv, lib, fetchFromGitHub, glib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "turnip";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Turnip";
    rev = "${version}";
    sha256 = "sha256-UVF+KR1NCJQU3Pj1MwnTw6U0T9bQk20FkQK4fZAI1To=";
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
