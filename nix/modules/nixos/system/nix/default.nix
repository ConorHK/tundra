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
          "https://cache.garnix.io"
          "https://hyprland.cachix.org"
          "https://nix-gaming.cachix.org"
          "https://nixpkgs-wayland.cachix.org"
          "https://cache.nixos.org"
        ];
        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
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
