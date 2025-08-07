{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.shells.zsh;
  processContent =
    content:
    if builtins.isPath content || builtins.isString content then
      if lib.hasSuffix ".zsh" content || lib.hasSuffix ".sh" content then
        builtins.readFile content
      else
        content
    else
      content;
in
{
  options.cli.shells.zsh = with types; {
    enable = mkOption {
      default = false;
      type = bool;
      description = "enable ZSh shell";
    };
    configExtras = mkOption {
      default = { };
      type = types.attrsOf (
        types.submodule {
          options = {
            # Can be either a string or a path to a file
            content = mkOption {
              type = types.oneOf [
                types.lines
                types.path
              ];
              description = "The configuration content or path to a file";
            };
            priority = mkOption {
              type = types.int;
              default = 1000;
              description = "Priority of the configuration (lower runs earlier)";
            };
          };
        }
      );
      description = ''
        Extra configuration to add to .zshrc
        Content can be either direct text or a path to a file.
        Common priority values:
        - 500: Early initialization
        - 550: Before completion initialization
        - 1000: General configuration (default)
        - 1500: Last to run configuration
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      sessionVariables.__HM_SESS_VARS_SOURCED = "";
      sessionVariables.LS_COLORS = "";
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;
      dotDir = "${config.home.homeDirectory}/.config/zsh";

      initContent =
        let
          zshPrompt = builtins.readFile ./prompt.zsh;
          configExtrasList = lib.mapAttrsToList (
            _name: value: lib.mkOrder value.priority (processContent value.content)
          ) cfg.configExtras;
        in
        lib.mkMerge (
          [
            zshPrompt # default priority 1000
          ]
          ++ configExtrasList
        );

      shellAliases = {
        nix = "noglob nix";
        home-manager = "noglob home-manager";
        upload-here = "nix-shell -E 'with (import <nixpkgs> {}); with python3; mkShell { buildInputs = [ (withPackages (p: [(pkgs.buildPythonPackage rec { pname = \"uploadserver\"; version = \"5.2.1\"; src = fetchPypi { inherit pname version; hash = \"sha256-qp2xkzLvnrnx8dHZpwlF3RjRg8jYC7WAaVS4ltJFZaU=\"; }; })]) ) ]; }' --run \"python -m uploadserver 9997\""; # TODO: move to own package
      };

      history = {
        extended = true;
        ignoreDups = true;
        ignoreSpace = true;
        size = 10000;
        share = true;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      plugins = [
        {
          name = "zsh-vim-mode";
          src = "${pkgs.zsh-vi-mode}/share/zsh-vi-mode";
        }
        {
          name = "fast-syntax-highlighting";
          inherit (pkgs.zsh-fast-syntax-highlighting) src;
        }
      ];
    };
  };
}
