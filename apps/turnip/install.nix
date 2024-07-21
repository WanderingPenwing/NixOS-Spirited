{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  glib,
}:
stdenv.mkDerivation rec {
  pname = "Turnip";
  version = "1.1";

  src = fetchurl {
    url = "https://github.com/WanderingPenwing/Turnip/releases/download/${version}/turnip_v${version}.tar.gz";
    hash = "sha256-RpdI3WvhU3KrHqXqZQOCXui9wQpDZFEEMLNQu2UX+yc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    glib
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D turnip $out/bin/turnip
    runHook postInstall
  '';

  meta = with lib; {
    description = "my status bar";
    homepage = "https://github.com/WanderingPenwing/Turnip";
  };
}
