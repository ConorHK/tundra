_: {
  flake.modules.homeManager.networking-tools =
    { pkgs, ... }:
    {
      home = {
        packages = with pkgs; [
          netcat
          sshuttle
          doggo
          net-snmp
        ];
        shellAliases.dig = "doggo";
      };
    };
}
