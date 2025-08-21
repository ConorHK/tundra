_: {
  flake.modules.homeManager.agenix =
    { pkgs, inputs, ... }:
    {
      home.packages = [
        inputs.agenix.packages.${pkgs.system}.default
      ];
    };
}
