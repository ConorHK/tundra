_: {
  flake.modules.homeManager.gpg =
    _:
    {
      programs.gpg.enable = true;
      services.gpg-agent = {
        enable = true;
        defaultCacheTtl = 1800;
        enableSshSupport = true;
        # pinentry.package = pkgs.pinentry-curses;
      };
    };
}
