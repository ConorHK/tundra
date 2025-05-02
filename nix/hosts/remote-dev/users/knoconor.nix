{ flake, inputs, ... }:
{
  imports = [
    flake.homeModules.roles
    inputs.stylix.homeManagerModules.stylix
  ];

  roles.home = {
    development.enable = true;
    work.enable = true;
  };

  home.sessionVariables.HOSTROLE = "dev";
  system.xdg.enable = true;

  cli.multiplexers.zellij.enableAutoStart = true;

  programs.zsh = {
    initExtraFirst = ''
      . "$HOME/.local/share/amazon-q/shell/zprofile.pre.zsh"
    '';
    initContent = ''
      . "$HOME/.local/share/amazon-q/shell/zprofile.post.zsh"
    '';
  };
}
