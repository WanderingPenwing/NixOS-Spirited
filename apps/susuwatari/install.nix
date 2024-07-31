{ stdenv, lib, fetchFromGitHub, autoPatchelfHook, glib, pkg-config, xorg, libevdev, rustPlatform}:

rustPlatform.buildRustPackage rec {
  pname = "susuwatari";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Susuwatari";
    rev = "${version}";
    sha256 = "sha256-4Z41ogZlasw4LkZmWxdcNwcloyDaMo+To+VTYdyaCLw=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock"; 
  };

  nativeBuildInputs = [
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = [
  	xorg.libX11
	xorg.libXi
	xorg.libXtst
    glib
	libevdev
  ];

  meta = with lib; {
    description = "my clipboard";
    homepage = "https://github.com/WanderingPenwing/Susuwatari";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
