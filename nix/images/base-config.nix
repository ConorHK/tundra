# images/base-config.nix
{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  networking = {
    useDHCP = false;
    hostName = "nixlive";
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;
    # interfaces.eth0.ipv4.addresses = [
    #   {
    #     address = "192.168.1.2";
    #     prefixLength = 24;
    #   }
    # ];
    # defaultGateway = "192.168.1.1";
    # nameservers = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ];
  };

  boot.supportedFilesystems = [
    "zfs"
    "f2fs"
  ];
  # serial connection for apu
  boot.kernelParams = [ "console=ttyS0,115200n8" ];

  users.mutableUsers = false;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM8okOt7lHfTjmabxdIruqIMxz0SwJuHSiGiC/so5IrM"
  ];
  users.users = {
    "nixos" = {
      isNormalUser = true;
      home = "/home/nixos";
      password = "";
      uid = 1000;
      extraGroups = [
        "systemd-journal"
        "wheel"
      ];
    };
  };

  # sshd
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = lib.mkForce "prohibit-password";
    hostKeys = [
      {
        type = "rsa";
        bits = 4096;
        path = "/etc/ssh/ssh_host_rsa_key";
      }
      {
        type = "ed25519";
        path = "/etc/ssh/ssh_host_ed25519_key";
      }
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.addresses = true;
    publish.domain = true;
    publish.enable = true;
    publish.userServices = true;
    publish.workstation = true;
  };

  # Turn on flakes.
  nix.package = pkgs.nixVersions.stable;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # includes this flake in the live iso : "/etc/nixcfg"
  environment.etc.nixcfg.source = builtins.filterSource (
    path: type:
    baseNameOf path != ".git"
    && type != "symlink"
    && !(pkgs.lib.hasSuffix ".qcow2" path)
    && baseNameOf path != "secrets"
  ) ../.;

  environment.systemPackages = [
    pkgs.git
    pkgs.htop
    pkgs.tmux
    pkgs.rsync
    pkgs.ripgrep
    pkgs.cryptsetup
    pkgs.nixpkgs-fmt
    inputs.cnvim.packages.${pkgs.system}.default
  ];

  ## FIX for running out of space / tmp, which is used for building
  fileSystems."/nix/.rw-store" = {
    fsType = "tmpfs";
    options = [
      "mode=0755"
      "nosuid"
      "nodev"
      "relatime"
      "size=14G"
    ];
    neededForBoot = true;
  };

  # Part of base-system.nix:
  time.timeZone = lib.mkDefault "Etc/UTC";

  i18n = {
    defaultLocale = "en_IE.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_GB.UTF-8";
    };
    supportedLocales = lib.mkDefault [
      "en_GB.UTF-8/UTF-8"
      "en_IE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };
  environment.variables = {
    TERM = "xterm-256color";
  };

  # # Use a high-res font.
  # boot.loader.systemd-boot.consoleMode = "0";
  console = {
    # https://github.com/NixOS/nixpkgs/issues/114698
    earlySetup = true; # Sets the font size much earlier in the boot process
    colors = [
      # # frappe colors
      "51576d"
      "e78284"
      "a6d189"
      "e5c890"
      "8caaee"
      "f4b8e4"
      "81c8be"
      "b5bfe2"
      "626880"
      "e78284"
      "a6d189"
      "e5c890"
      "8caaee"
      "f4b8e4"
      "81c8be"
      "a5adce"
    ];
    font = "Lat2-Terminus16";
    useXkbConfig = true; # Use same config for linux console
  };

  services.xserver = {
    enable = lib.mkDefault false; # but still here so we can copy the XKB config to TTYs
    autoRepeatDelay = 300;
    autoRepeatInterval = 35;
  };
}
