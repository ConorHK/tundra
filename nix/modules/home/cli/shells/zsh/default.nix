{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.cli.shells.zsh;
in
{
  options.cli.shells.zsh = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable ZSh shell";
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
      dotDir = ".config/zsh";
      initContent = let 
        zshPrompt = builtins.readFile ./prompt.zsh;
      in
      lib.mkMerge [zshPrompt];
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
