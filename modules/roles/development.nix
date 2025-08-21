{ inputs, ... }:
{
  flake.modules.homeManager.development =
    { ... }:
    {
      imports = [
        inputs.self.modules.homeManager.cnvim
        inputs.self.modules.homeManager.git
        inputs.self.modules.homeManager.jq
        inputs.self.modules.homeManager.gpg
        inputs.self.modules.homeManager.jujutsu
        inputs.self.modules.homeManager.networking-tools
        inputs.self.modules.homeManager.nix-your-shell
        inputs.self.modules.homeManager.ripgrep
        inputs.self.modules.homeManager.script-directory
        inputs.self.modules.homeManager.wget
      ];
    };
}
