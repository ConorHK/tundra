{ inputs, ... }:
{
  imports = [
    ../../../modules/home/common-role.nix
    ../../../modules/home/development-role.nix
    ../../../modules/home/work-role.nix
    inputs.stylix.homeModules.stylix
  ];

  home.username = "knoconor";
  home.homeDirectory = "/home/knoconor";
  roles.home = {
    development.enable = true;
    work.enable = true;
  };

  programs.fish.shellAliases = {
    ns = "home-manager switch --flake .#knoconor@remote-dev";
  };

  home.sessionVariables.HOSTROLE = "dev";
  system.xdg.enable = true;


  cli = {
    multiplexers.zellij.enableAutoStart = true;
    shells = {
      zsh.enable = false;
      fish.enable = true;
    };
    editors.cnvim.categoryOverrides = {
      bash = true;
      diagnostics = true;
      git = true;
      java = true;
      lsp = true;
      lua = true;
      nix = true;
      python = true;
      snippets = true;
      surround = true;
      treesitter = true;
      typescript = true;
      zellij = true;
    };
  };
}
