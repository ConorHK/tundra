{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

with lib;

let
  cfg = config.system.agenix;
  secret = pkgs.writeScriptBin "secret" ''
    #!/usr/bin/env bash

    SECRETS_DIR="$(git rev-parse --show-toplevel)/secrets"

    case "$1" in
      "edit")
        if [ -z "$2" ]; then
          echo "Usage: agenix-helper edit <secret-name>"
          echo "Available secrets:"
          find "$SECRETS_DIR" -name "*.age" -type f | sed "s|$SECRETS_DIR/||" | sed 's|\.age$||'
          exit 1
        fi
        agenix -e "$SECRETS_DIR/$2.age"
        ;;
      "rekey")
        echo "Rekeying all secrets..."
        agenix -r -i "$SECRETS_DIR/default.nix"
        ;;
      "list")
        echo "Available secrets:"
        find "$SECRETS_DIR" -name "*.age" -type f | sed "s|$SECRETS_DIR/||" | sed 's|\.age$||'
        ;;
      *)
        echo "Agenix helper for Tundra"
        echo "Usage: agenix-helper <command>"
        echo ""
        echo "Commands:"
        echo "  edit <secret>  - Edit a secret"
        echo "  rekey          - Rekey all secrets"
        echo "  list           - List available secrets"
        ;;
    esac
  '';

in
{
  options.system.agenix = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable agenix secret management";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.agenix.packages.${system}.default
      secret
    ];
  };
}
