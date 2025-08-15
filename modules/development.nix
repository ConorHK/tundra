{ inputs, ... }:
{
  flake.modules.homeManager.development =
    { ... }:
    {
      imports = [
        inputs.self.modules.homeManager.cnvim
        inputs.self.modules.homeManager.git
        inputs.self.modules.homeManager.jq
      ];
    };
}
