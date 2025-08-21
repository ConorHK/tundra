_: {
  flake.modules.homeManager.zellij =
    {
      inputs,
      pkgs,
      lib,
      ...
    }:
    let

      sesh = pkgs.writeScriptBin "sesh" ''
        #! /usr/bin/env sh

        select_session() {
          ZJ_SESSIONS=$(zellij list-sessions -s)
          NO_SESSIONS=$(echo "$ZJ_SESSIONS" | wc -l)

          if [ -z "$ZELLIJ" ]; then
            if [ "$NO_SESSIONS" -ge 2 ]; then
              zellij attach \
              "$(echo "$ZJ_SESSIONS" | ${pkgs.fzf}/bin/fzf)"
            else
               zellij attach -c
            fi
          fi
        }
        select_session
        [ $? -ne 0 ] && zellij attach -c "default"
      '';
    in
    {
      home.packages = [
        pkgs.fzf
        sesh
        pkgs.zellij
      ];

      xdg.configFile."zellij/config.kdl".text = lib.concatStringsSep "\n" [
        ''
          default_shell "fish"

          default_layout "compact"
          show_startup_tips false
          theme "onedark"

          pane_viewport_serialization false
          scrollback_lines_to_serialize 5000

          ui {
            pane_frames {
              rounded_corners true;
            }
          }

          plugins {
            autolock location="file://${inputs.self.packages.${pkgs.system}.zellij-autolock}" {
              triggers "nvim|vim|cnvim"
              watch_triggers "fzf|zoxide|atuin"
              watch_interval "1.0"
            }
          }
          load_plugins {
            autolock
          }

          keybinds clear-defaults=true {
            locked {
              bind "Ctrl t" { SwitchToMode "Tmux"; }
              bind "Ctrl q" { SwitchToMode "Locked"; }
            }

            normal {
              bind "Enter" {
                WriteChars "\u{000D}";
                MessagePlugin "autolock" {};
              }

              bind "Ctrl t" { SwitchToMode "Tmux"; }
              bind "Ctrl Left" "Ctrl h" { MoveFocus "Left"; }
              bind "Ctrl Right" "Ctrl l" { MoveFocus "Right"; }
              bind "Ctrl Up" "Ctrl k" { MoveFocus "Up"; }
              bind "Ctrl Down" "Ctrl j" { MoveFocus "Down"; }

              unbind "Ctrl b"
            }
            tmux {
              bind "Ctrl t" { Write 2; SwitchToMode "Normal"; }
              bind "Esc" { SwitchToMode "Normal"; }

              bind "g" { SwitchToMode "Locked"; }
              bind "p" { SwitchToMode "Pane"; }
              bind "t" { SwitchToMode "Tab"; }
              bind "n" { SwitchToMode "Resize"; }
              bind "h" { SwitchToMode "Move"; }
              bind "s" { SwitchToMode "Session"; }
              bind "o" { SwitchToMode "Scroll"; }
              bind "?" { SwitchToMode "EnterSearch"; SearchInput 0; }

              bind "q" { Quit; }
            }
            pane {
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }

              bind "Ctrl Left" "Ctrl h" { MoveFocus "Left"; }
              bind "Ctrl Right" "Ctrl l" { MoveFocus "Right"; }
              bind "Ctrl Up" "Ctrl k" { MoveFocus "Up"; }
              bind "Ctrl Down" "Ctrl j" { MoveFocus "Down"; }

              bind "v" { NewPane "Right"; SwitchToMode "Normal"; }
              bind "h" { NewPane "Down"; SwitchToMode "Normal"; }
              bind "z" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
              bind "x" { CloseFocus; SwitchToMode "Normal"; }
            }
            tab {
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }

              bind "c" { NewTab; SwitchToMode "Normal"; }
              bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
              bind "n" { GoToNextTab; SwitchToMode "Normal"; }
              bind "p" { GoToPreviousTab; SwitchToMode "Normal"; }
            }
            renametab {
              bind "Ctrl c" "Enter" { SwitchToMode "Normal"; }
              bind "Esc" { UndoRenameTab; SwitchToMode "Tab"; }
            }
            renamepane {
              bind "Ctrl c" "Enter" { SwitchToMode "Normal"; }
              bind "Esc" { UndoRenamePane; SwitchToMode "Pane"; }
            }
            resize {
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }
              bind "Left" "h" { Resize "Increase Left"; }
              bind "Right" "l" { Resize "Increase Right"; }
              bind "Up" "k" { Resize "Increase Up"; }
              bind "Down" "j" { Resize "Increase Down"; }
            }
            move {
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }
            }
            scroll {
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }

              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "h" "Left" { PageScrollUp; }
              bind "l" "Right" { PageScrollDown; }
              bind "Ctrl d" { HalfPageScrollDown; }
              bind "Ctrl u" { HalfPageScrollUp; }
              bind "g" { ScrollToTop; }
              bind "G" { ScrollToBottom; }
              bind "Space" { PageScrollDown; }
              bind "v" { EditScrollback; }
              bind "Space" { EditScrollback; }
            }
            session {
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }

              bind "d" { Detach; }
              bind "s" {
                  LaunchOrFocusPlugin "session-manager" {
                      floating true
                      move_to_focused_tab true
                  };
                  SwitchToMode "Normal"
              }
            }
            entersearch {
              bind "Ctrl c" "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Search"; }
            }
            search {
              bind "Esc" { SwitchToMode "Normal"; }
              bind "Enter" { SwitchToMode "Normal"; }

              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "Ctrl d" { PageScrollDown; }
              bind "Ctrl u" { PageScrollUp; }
              bind "n" { Search "down"; }
              bind "b" { Search "up"; }
            }
          }
        ''
      ];

    };
}
