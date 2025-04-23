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
