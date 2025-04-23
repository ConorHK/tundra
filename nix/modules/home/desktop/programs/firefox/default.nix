{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.desktop.programs.firefox;
in
with lib;
{
  options.desktop.programs.firefox = {
    enable = mkOption {
      default = false;
      type = with types; bool;
      description = "enable firefox";
    };
  };

  config = mkIf cfg.enable {
    programs = {
      firefox = {
        enable = true;
        policies = {
          DontCheckDefaultBrowser = true;
          DisableTelemetry = true;
          DisableFirefoxStudies = true;
          DisablePocket = true;
          DisableFirefoxScreenshots = true;

          DisplayBookmarksToolbar = "never";
          DisplayMenuBar = "never"; # Previously appeared when pressing alt

          OverrideFirstRunPage = "";
          PictureInPicture.Enabled = false;
          PromptForDownloadLocation = false;

          HardwareAcceleration = true;
          TranslateEnabled = true;

          Homepage.StartPage = "previous-session";

          UserMessaging = {
            UrlbarInterventions = false;
            SkipOnboarding = true;
          };

          FirefoxSuggest = {
            WebSuggestions = false;
            SponsoredSuggestions = false;
            ImproveSuggest = false;
          };

          EnableTrackingProtection = {
            Value = true;
            Cryptomining = true;
            Fingerprinting = true;
          };

          FirefoxHome = # Make new tab only show search
            {
              Search = true;
              TopSites = false;
              SponsoredTopSites = false;
              Highlights = false;
              Pocket = false;
              SponsoredPocket = false;
              Snippets = false;
            };
        };
        profiles = {
          default = {
            id = 0;
            name = "default";
            isDefault = true;
            settings = {
              "browser.startup.homepage" = "https://priv.au";
              "browser.search.defaultenginename" = "Searx";
              "browser.search.order.1" = "Searx";
              "signon.rememberSignons" = false;
              "widget.use-xdg-desktop-portal.file-picker" = 1;
              "browser.aboutConfig.showWarning" = false;
              "browser.compactmode.show" = true;
              "browser.cache.disk.enable" = false; # Be kind to hard drive

              # sidebery
              "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            };
            search = {
              force = true;
              default = "Searx";
              order = [
                "Searx"
                "google"
              ];
              engines = {
                "Nix Packages" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                "NixOS Wiki" = {
                  urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
                  icon = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@nw" ];
                };
                "Searx" = {
                  urls = [ { template = "https://priv.au/?q={searchTerms}"; } ];
                  icon = "https://nixos.wiki/favicon.png";
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  definedAliases = [ "@searx" ];
                };
                "bing".metaData.hidden = true;
                "google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias
              };
            };
            extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
              absolute-enable-right-click
              bitwarden
              darkreader
              istilldontcareaboutcookies
              sidebery
              sponsorblock
              ublock-origin
              vimium
            ];
            userChrome = ''
              #TabsToolbar
              {
                  visibility: collapse;
              }
              #sidebar-header {
                display: none;
              }
            '';
          };
        };
      };
    };
  };
}
