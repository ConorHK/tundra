{ pkgs, ... }:
pkgs.stdenvNoCC.mkDerivation {
  name = "wallpapers";
  version = "1.0";
  src = ./assets;

  installPhase = ''
    mkdir -p $out/wallpapers/
    cp -r $src/*.png $out/wallpapers/
  '';
}
