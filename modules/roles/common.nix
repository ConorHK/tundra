{ inputs, ... }:
{
  flake.modules.homeManager.common =
    { ... }:
    {
      imports = [
        inputs.self.modules.homeManager.bat
        inputs.self.modules.homeManager.btop
        inputs.self.modules.homeManager.comma
        inputs.self.modules.homeManager.duf
        inputs.self.modules.homeManager.dust
        inputs.self.modules.homeManager.eza
        inputs.self.modules.homeManager.fish
        inputs.self.modules.homeManager.fzf
        inputs.self.modules.homeManager.less
        inputs.self.modules.homeManager.nh
        inputs.self.modules.homeManager.ssh
        inputs.self.modules.homeManager.zoxide
      ];
    };
}
