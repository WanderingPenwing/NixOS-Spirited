{
  pkgs,
  fetchurl,
}:
pkgs.stdenv.mkDerivation rec {
  pname = "calcifer";
  version = "1.2";

  # src = fetchurl {
  #   url = "https://github.com/WanderingPenwing/Calcifer/releases/download/1.2/calcifer-v1.2.tar.gz";
  #   sha256 = "fd0d7be09dd669d6ad3b87752eeb8c8c8069871d6f6869ce4ab65efd6fb4f0a0";
  # };
  src = "/home/penwing/nixos/apps/calcifer/calcifer-v1.2.tar.gz";

  nativeBuildInputs = [pkgs.libxkbcommon]; # Keep libxkbcommon as a build input

  # cp -a $src $out/bin/calcifer
  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/calcifer
    # Set LD_LIBRARY_PATH in a post-installation hook
    mkdir -p $out/etc/profile.d
    echo 'export LD_LIBRARY_PATH=/run/opengl-driver/lib/:${pkgs.lib.makeLibraryPath [pkgs.libxkbcommon]}' > $out/etc/profile.d/calcifer_ld_library_path.sh
  '';

  meta = with pkgs.lib; {
    description = "My Fiery IDE";
    homepage = "https://github.com/WanderingPenwing/Calcifer";
    license = licenses.mit;
    maintainers = [];
  };
}
