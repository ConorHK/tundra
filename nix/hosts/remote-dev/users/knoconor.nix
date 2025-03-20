{ flake, lib, inputs, ... }:
with lib;
{
  imports = [
    flake.homeModules.common-role
    flake.homeModules.development-role
    flake.homeModules.work-role
    inputs.stylix.homeManagerModules.stylix
  ];
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
      . "$HOME/.local/share/amazon-q/shell/zshrc.pre.zsh"
    '';
  initExtra = ''
      . "$HOME/.local/share/amazon-q/shell/zshrc.post.zsh"
    '';
  };
}
