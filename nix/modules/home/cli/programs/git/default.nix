{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cli.programs.git;
  shellCfg = config.cli.shells;
  aliases = {
    gs = "git status";
    gc = "git commit";
    ga = "git add";
    gaa = "git add --all";
    gp = "git push";
    gl = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
    gd = "git -c diff.external=difft diff";
    grc = "git -c diff.external=difft show --ext-diff";
  };
in
with lib;
{
  options = {
    cli.programs.git = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "enable git";
      };
      defaultBranch = mkOption {
        default = "main";
        type = with types; str;
        description = "default git branch";
      };
      email = mkOption {
        default = "";
        type = with types; str;
        description = "default git email";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mergiraf
      difftastic
      git-absorb
    ];
    programs = {
      git = {
        enable = true;
        userName = "Conor Knowles";
        userEmail = cfg.email;
        extraConfig = {
          init = {
            inherit (cfg) defaultBranch;
          };
          pull = {
            rebase = true;
          };
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
        ignores = [
          "CLAUDE.md"
          ".claude"
        ];
        lfs.enable = true;
      };

      zsh.shellAliases = mkIf shellCfg.zsh.enable aliases;
      fish.shellAbbrs = mkIf shellCfg.fish.enable aliases;
    };
  };
}
