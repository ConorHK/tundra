{
  inputs,
  pkgs,
  ...
}:

{
  # setup:
  # nix run nixpkgs#nixos-generators -- -f sd-aarch64 --flake .#satelite --system aarch64-linux -o ./pi.sd
  # unzstd -d nixos-image-sd-card-25.11.20250730.e44b8dc-aarch64-linux.img.zst -o /tmp/nixos-sd.img
  # sudo dd if=/tmp/nixos-sd.img of=/dev/sda bs=1M status=progress
  imports = [
    inputs.disko.nixosModules.disko

    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }

    ./hardware-configuration.nix
    ../../modules/nixos/common-role.nix
  ];

  styles.stylix.enableNixOs = false;

  system.boot.enable = false;
  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = false;
    generic-extlinux-compatible.enable = true;
    grub.enable = false;
  };

  services = {
    sshd.enable = true;
    spotifydaemon.enable = true;
  };

  hardware.audio.enable = true;

  users.users."driver".hashedPasswordFile = null;
  user = {
    name = "driver";
    extraOptions = {
      description = "admin";
      uid = 1000;
    };
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
    raspberrypi-eeprom
    espeak-ng
  ];

  system.nixbuild.enable = true;

  services.pulseaudio.extraConfig = ''
    unload-module module-suspend-on-idle
  '';

  system.activationScripts.asound =
    let
      initialAsoundState = ./files/asound.state;
    in
    ''
      if [ ! -e "/var/lib/alsa/asound.state" ]; then
        mkdir -p /var/lib/alsa
        cp ${initialAsoundState} /var/lib/alsa/asound.state
      fi
    '';

  networking.hostName = "satelite";
  system.stateVersion = "25.05";
}
