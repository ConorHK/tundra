{ config, ... }:
{
  age = {
    identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
    secrets = {
      ntfy = {
        file = ../../secrets/ntfy.age;
      };
    };
  };
}
