{ lib, ... }:
{
  flake.modules.homeManager.git =
    { config, pkgs, ... }:
    {
      assertions = [
        {
          assertion = config.programs.git.userName != "";
          message = "git module requires programs.git.userName to be set";
        }
        {
          assertion = config.programs.git.userEmail != "";
          message = "git module requires programs.git.userEmail to be set";
        }
      ];

      home.packages = with pkgs; [
        mergiraf
        difftastic
        git-absorb
      ];

      programs.git = {
        enable = true;
        userName = lib.mkDefault "Conor Knowles";
        userEmail = lib.mkDefault "dev@conorknowles.com";

        extraConfig = {
          init.defaultBranch = lib.mkDefault "main";
          pull.rebase = true;
          merge.mergiraf = {
            name = "mergiraf";
            driver = "mergiraf merge --git %O %A %B -s %S -x %X -y %Y -p %P";
          };
        };
        attributes = [
          "*.java merge=mergiraf"
          "*.rs merge=mergiraf"
          "*.go merge=mergiraf"
          "*.js merge=mergiraf"
          "*.jsx merge=mergiraf"
          "*.json merge=mergiraf"
          "*.yml merge=mergiraf"
          "*.yaml merge=mergiraf"
          "*.toml merge=mergiraf"
          "*.html merge=mergiraf"
          "*.htm merge=mergiraf"
          "*.xhtml merge=mergiraf"
          "*.xml merge=mergiraf"
          "*.c merge=mergiraf"
          "*.cc merge=mergiraf"
          "*.h merge=mergiraf"
          "*.cpp merge=mergiraf"
          "*.hpp merge=mergiraf"
          "*.cs merge=mergiraf"
          "*.dart merge=mergiraf"
          "*.scala merge=mergiraf"
          "*.sbt merge=mergiraf"
          "*.ts merge=mergiraf"
          "*.py merge=mergiraf"
        ];
        lfs.enable = true;
      };

      home.shellAliases = {
        gs = "git status";
        gc = "git commit";
        ga = "git add";
        gaa = "git add --all";
        gp = "git push";
        gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        gd = "git -c diff.external=difft diff";
        grc = "git -c diff.external=difft show --ext-diff";
      };
    };
}
