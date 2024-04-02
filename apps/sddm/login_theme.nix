{
  pkgs,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "where-is-my-sddm-theme";
  version = "1.6.1";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "stepanzubkov";
    repo = "where-is-my-sddm-theme";
    rev = "v${version}";
    sha256 = "0r1ap4lbqfm2fns6innjamf5q5giz82fwhkfxrv34f77gi79ah0z";
  };

  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src/where_is_my_sddm_theme $out/share/sddm/themes/where-is-my-sddm-theme
  '';

  # # Copy theme.conf from the same directory as the Nix expression
  # buildInputs = [pkgs.writeTextFile];
  # preBuild = ''
  #   cp ${toString ./theme.conf} $src/where_is_my_sddm_theme/theme.conf
  # '';
}
