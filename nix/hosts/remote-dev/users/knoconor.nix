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

  home = {
    sessionVariables = {
      HOSTROLE = "dev";
      BROWSER = "echo"; # print URLs
    };
    stateVersion = "25.05";
  };
  system.xdg.enable = true;

  cli.multiplexers.zellij.enableAutoStart = true;

  programs.zsh = {
    initExtraFirst = ''
      . "$HOME/.local/share/amazon-q/shell/zprofile.pre.zsh"
    '';
    initExtra = ''
      . "$HOME/.local/share/amazon-q/shell/zprofile.post.zsh"
    '';
  };
}
