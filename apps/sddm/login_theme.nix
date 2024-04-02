{
  pkgs,
  stdenvNoCC,
  ... # other arguments if present
}:
stdenvNoCC.mkDerivation rec {
  pname = "where-is-my-sddm-theme";
  version = "1.6.1";
  dontBuild = false; # Set to false to allow installPhase execution
  src = ./theme; # Path to the local folder
  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/where-is-my-sddm-theme
  '';
}
