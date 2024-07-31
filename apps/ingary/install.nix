{
  lib,
  qtbase,
  qtsvg,
  qtgraphicaleffects,
  qtquickcontrols2,
  wrapQtAppsHook,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation
rec {
  pname = "ingary";
  version = "2.1.3";
  dontBuild = true;
  
  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "Ingary";
    rev = "v${version}";
    sha256 = "sha256-WbP95slXNOlV59f/3zkNbLpPL/n6iHfN7G3My5s+Co0=";
  };
  
  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedUserEnvPkgs = [
    qtbase
    qtsvg
    qtgraphicaleffects
    qtquickcontrols2
  ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/ingary
  '';
}
