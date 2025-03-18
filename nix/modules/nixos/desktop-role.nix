{
  pkgs,
  flake,
  ...
}:
{
  desktop = {
    environment.gnome.enable = true;
  };
  hardware.audio.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  security.yubikey.enable = true;
  imports = [
    flake.nixosModules.desktop
    flake.nixosModules.hardware
    flake.nixosModules.security
  ];
}
