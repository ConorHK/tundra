{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.services.shell-web;

  # Create scripts directory with all defined scripts
  scriptsDir = pkgs.linkFarm "shell-web-scripts" (
    lib.mapAttrsToList (name: content: {
      inherit name;
      path = pkgs.writeTextFile {
        inherit name;
        text = content;
        executable = true;
      };
    }) cfg.scripts
  );

  shell-web-script = pkgs.writeScriptBin "shell-web" ''
    #!${pkgs.bash}/bin/bash
    export PYTHONPATH=${pkgs.python3.withPackages (ps: with ps; [ flask ])}/${pkgs.python3.sitePackages}
    exec ${pkgs.python3}/bin/python3 ${./shell-web.py} \
      --port ${toString cfg.port} \
      --scripts-dir ${scriptsDir} \
      --user ${cfg.scriptUser}
  '';
in
{
  options.services.shell-web = {
    enable = mkEnableOption "Shell web service";
    port = mkOption {
      type = types.int;
      default = 8081;
      description = "Port to run the shell web service on";
    };
    user = mkOption {
      type = types.str;
      default = "shell-web";
      description = "User to run the service as";
    };
    scriptUser = mkOption {
      type = types.str;
      default = "driver";
      description = "User to execute shell scripts as";
    };
    scripts = mkOption {
      type = types.attrsOf types.lines;
      default = { };
      example = {
        restart_nginx = ''
          systemctl restart nginx
        '';
        say_hello = ''
          echo "Hello from shell-web!"
        '';
      };
      description = "Attribute set of scripts; key is filename, value is script contents.";
    };
  };
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = "shell-web";
    };
    users.groups.shell-web = { };

    # Grant sudo permissions for shell-web user to run bash as script user
    security.sudo.extraRules = [
      {
        users = [ cfg.user ];
        runAs = cfg.scriptUser;
        commands = [
          {
            command = "${pkgs.bash}/bin/bash";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    systemd.services.shell-web = {
      description = "Shell Web Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${shell-web-script}/bin/shell-web";
        User = cfg.user;
        Group = "shell-web";
        Restart = "always";
        RestartSec = 5;
      };
      environment = {
        PYTHONPATH = "${pkgs.python3.withPackages (ps: with ps; [ flask ])}/${pkgs.python3.sitePackages}";
      };
    };

    environment.systemPackages = with pkgs; [
      (python3.withPackages (ps: with ps; [ flask ]))
    ];
  };
}
