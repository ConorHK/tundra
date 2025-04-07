{
  pkgs,
  ...
}:
{
  hardware = {
    uinput.enable = true;
    steam-hardware.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        mesa
      ];
    };
  };

  services.ratbagd.enable = true;

  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs =
          p: with p; [
            mangohud
            gamemode
          ];
      };
      dedicatedServer.openFirewall = false;
      remotePlay.openFirewall = false;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    winetricks
    wineWowPackages.waylandFull
    adwsteamgtk
    heroic
  ];

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];
}
