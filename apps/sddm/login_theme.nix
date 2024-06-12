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
  pname = "ghibli-sddm-theme";
  version = "1.8";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "WanderingPenwing";
    repo = "ghibli-sddm-theme";
    rev = "v${version}";
    sha256 = "0ndq90vgr52i69rl0737m69sl27f98qz2slkjv5b5yj0c4i7k6sy";
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
    cp -aR $src $out/share/sddm/themes/ghibli-sddm-theme
  '';
}
