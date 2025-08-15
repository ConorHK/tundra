_: {
  flake.modules.homeManager.atuin = {
    programs.atuin = {
      enable = true;
      settings = {
        sync_address = "";
        inline_height = 10;
        dialect = "uk";
        update_check = "false";
        filter_mode_shell_up_key_binding = "workspace";
        keymap_mode = "vim-normal";
        common_subcommands = [
          "apt"
          "cargo"
          "composer"
          "dnf"
          "docker"
          "git"
          "go"
          "ip"
          "kubectl"
          "nix"
          "nmcli"
          "npm"
          "pecl"
          "pnpm"
          "podman"
          "port"
          "systemctl"
          "tmux"
          "yarn"
          "brazil"
        ];
      };
    };
  };
}
