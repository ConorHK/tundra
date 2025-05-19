{ flake, inputs, ... }:
{
  imports = [
    flake.homeModules.roles
    inputs.stylix.homeModules.stylix
  ];
}
