{ flake, inputs, ... }:
{
  imports = [
    flake.homeModules.roles
    inputs.stylix.homeManagerModules.stylix
  ];
}
