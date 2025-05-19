{ flake, inputs, ... }:
{
  imports = [
    flake.homeModules.roles
    inputs.stylix.homeModules.stylix
  ];

  roles.home = {
    development.enable = true;
    work.enable = true;
  };

  home.sessionVariables.HOSTROLE = "dev";
  system.xdg.enable = true;

  cli.multiplexers.zellij.enableAutoStart = true;

  cli.shells.zsh = {
    configExtras = {
      pre-q = {
        content = ". \"$HOME/.local/share/amazon-q/shell/zprofile.pre.zsh\"";
        priority = 500;
      };
      post-q = {
        content = ". \"$HOME/.local/share/amazon-q/shell/zprofile.post.zsh\"";
        priority = 1500;
      };
    };
  };
}
