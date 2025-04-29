{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.system.nix;
in
{
  options.system.nix = with types; {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "configure nix settings";
    };
  };

  config = mkIf cfg.enable {
    nix = {
      settings = {
        allowed-users = [ "@wheel" ];
        trusted-users = [
          "@wheel"
          "root"
        ];
        max-free = mkDefault (3000 * 1024 * 1024);
        min-free = mkDefault (512 * 1024 * 1024);
        connect-timeout = 5;
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        auto-optimise-store = lib.mkDefault true;
        use-xdg-base-directories = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;
        system-features = [
          "big-parallel"
          "nixos-test"
        ];
      };
    };
  };
}
