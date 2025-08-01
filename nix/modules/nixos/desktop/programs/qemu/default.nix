{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.desktop.programs.qemu;
in
{
  options.desktop.programs.qemu = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable qemu";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
              }).fd];
        };
      };
  };
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    qemu
  ];
  virtualisation.spiceUSBRedirection.enable = true;
  boot.kernelModules = ["kvm-amd" "kvm-intel"];
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
