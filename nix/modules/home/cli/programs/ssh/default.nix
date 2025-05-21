{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.cli.programs.ssh;
in
{
  options.cli.programs.ssh = with types; {
    enable = lib.mkOption {
      description = "enable ssh";
      default = false;
      type = types.bool;
    };

    extraHosts = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            hostname = lib.mkOption {
              type = lib.types.str;
              description = "The hostname or IP address of the SSH host";
            };
            identityFile = lib.mkOption {
              type = lib.types.str;
              description = "The path to the identity file for the SSH host";
              default = "~/.ssh/id_ed25519";
            };
            user = lib.mkOption {
              type = lib.types.str;
              description = "The default user to log in with";
            };
            port = lib.mkOption {
              type = lib.types.int;
              description = "The default port to use";
            };
            forwardAgent = lib.mkOption {
              type = lib.types.nullOr lib.types.bool;
              description = "Enable forward SSH agent";
              default = null;
            };
          };
        }
      );
      default = { };
      description = "A set of extra SSH hosts.";
      example = literalExample ''
        {
          "gitlab-personal" = {
            hostname = "gitlab.com";
            identityFile = "~/.ssh/id_ed25519_personal";
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.keychain = {
      enable = true;
      keys = [ "id_ed25519" ];
    };

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      matchBlocks = cfg.extraHosts;
    };
  };
}
