{ config, pkgs, lib, inputs, ... }:
let
  noctaliaMsg = cmd: [ "noctalia" "msg" ] ++ (lib.splitString " " cmd);
  zenBrowser = lib.getExe inputs.zen-browser-flake.packages.${pkgs.system}.default;
in
{
  programs.niri = {
    package = pkgs.niri;
    settings = {
      prefer-no-csd = true;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      hotkey-overlay.skip-at-startup = true;

      input = {
        keyboard = {
          repeat-delay = 250;
          repeat-rate = 40;
          numlock = true;
          xkb = {
            layout = "latam";
          };
        };
        touchpad = { tap = true; };
        mouse.accel-profile = "flat";
        focus-follows-mouse = { max-scroll-amount = "0%"; };
      };

      layout = {
        gaps = 5;
        center-focused-column = "never";
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 0.5; }
          { proportion = 2.0 / 3.0; }
        ];
        default-column-width = { proportion = 0.5; };
        focus-ring = {
          width = 2;
          active = { color = "#7fc8ff"; };
          inactive = { color = "#505050"; };
        };
        border = {
          enable = false;
          width = 1.5;
          active = { color = "#ffc87f"; };
          inactive = { color = "#505050"; };
        };
        shadow = {
          softness = 30;
          spread = 5;
          offset = { x = 0; y = 5; };
          color = "#0007";
        };
      };

      workspaces = {
        "w0" = {}; "w1" = {}; "w2" = {}; "w3" = {}; "w4" = {};
        "w5" = {}; "w6" = {}; "w7" = {}; "w8" = {}; "w9" = {};
      };

      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

      spawn-at-startup = [
        { command = [ "noctalia" ]; }
        { command = [
            (lib.getExe pkgs.swaybg)
            "-i" "${config.home.homeDirectory}/Pictures/Wallpapers/default.jpg"
            "-m" "fill"
          ];
        }
      ];

      window-rules = [
        {
          matches = [{ app-id = "^zen-beta$"; title = "^Picture-in-Picture$"; }];
          open-floating = true;
        }
        {
          geometry-corner-radius = {
            top-left = 4.0;
            top-right = 4.0;
            bottom-left = 4.0;
            bottom-right = 4.0;
          };
          clip-to-geometry = true;
        }
      ];

      binds = with config.lib.niri.actions; {
        # Navigation
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        "Mod+Left".action = focus-column-left;
        "Mod+Right".action = focus-column-right;
        "Mod+Up".action = focus-window-up;
        "Mod+Down".action = focus-window-down;

        # Move columns/windows
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+J".action = move-window-down;

        # Resize
        "Mod+Ctrl+H".action = set-column-width "-5%";
        "Mod+Ctrl+L".action = set-column-width "+5%";
        "Mod+Ctrl+J".action = set-window-height "-5%";
        "Mod+Ctrl+K".action = set-window-height "+5%";

        # Workspaces (w0-w9)
        "Mod+1".action = focus-workspace "w0";
        "Mod+2".action = focus-workspace "w1";
        "Mod+3".action = focus-workspace "w2";
        "Mod+4".action = focus-workspace "w3";
        "Mod+5".action = focus-workspace "w4";
        "Mod+6".action = focus-workspace "w5";
        "Mod+7".action = focus-workspace "w6";
        "Mod+8".action = focus-workspace "w7";
        "Mod+9".action = focus-workspace "w8";
        "Mod+0".action = focus-workspace "w9";

        "Mod+Shift+1".action."move-column-to-workspace" = "w0";
        "Mod+Shift+2".action."move-column-to-workspace" = "w1";
        "Mod+Shift+3".action."move-column-to-workspace" = "w2";
        "Mod+Shift+4".action."move-column-to-workspace" = "w3";
        "Mod+Shift+5".action."move-column-to-workspace" = "w4";
        "Mod+Shift+6".action."move-column-to-workspace" = "w5";
        "Mod+Shift+7".action."move-column-to-workspace" = "w6";
        "Mod+Shift+8".action."move-column-to-workspace" = "w7";
        "Mod+Shift+9".action."move-column-to-workspace" = "w8";
        "Mod+Shift+0".action."move-column-to-workspace" = "w9";

        # Window management
        "Mod+Q".action = close-window;
        "Mod+F".action = maximize-column;
        "Mod+G".action = fullscreen-window;
        "Mod+Shift+F".action = toggle-window-floating;
        "Mod+C".action = center-column;

        # Terminal + launcher
        "Mod+Return".action = spawn [ (lib.getExe pkgs.ghostty) ];
        "Mod+S".action.spawn = noctaliaMsg "panel-toggle launcher";

        # App launches
        "Mod+Shift+B".action = spawn [ zenBrowser ];
        "Mod+Shift+T".action = spawn [ (lib.getExe pkgs.telegram-desktop) ];
        "Mod+Shift+D".action = spawn [ (lib.getExe pkgs.discord) ];
        "Mod+Shift+A".action = spawn [ (lib.getExe pkgs.pavucontrol) ];

        # Screenshots
        "Mod+Shift+S".action.spawn = [
          (lib.getExe pkgs.bash) "-c"
          ''${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - | ${pkgs.wl-clipboard}/bin/wl-copy''
        ];
        "Mod+Ctrl+S".action.spawn = [
          (lib.getExe pkgs.bash) "-c"
          "${lib.getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy"
        ];
        "Mod+Ctrl+E".action.spawn = [
          (lib.getExe pkgs.bash) "-c"
          "${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -"
        ];

        # Audio (wireplumber is a system dep via PipeWire in system/audio.nix)
        "XF86AudioRaiseVolume".action.spawn =
          [ (lib.getExe' pkgs.wireplumber "wpctl") "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "5%+" ];
        "XF86AudioLowerVolume".action.spawn =
          [ (lib.getExe' pkgs.wireplumber "wpctl") "set-volume" "-l" "1.4" "@DEFAULT_AUDIO_SINK@" "5%-" ];
        "XF86AudioMute".action.spawn =
          [ (lib.getExe' pkgs.wireplumber "wpctl") "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle" ];
        "XF86AudioMicMute".action.spawn =
          [ (lib.getExe' pkgs.wireplumber "wpctl") "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle" ];

        # Brightness
        "XF86MonBrightnessUp".action = spawn [
          (lib.getExe pkgs.brightnessctl) "--class=backlight" "set" "+10%"
        ];
        "XF86MonBrightnessDown".action = spawn [
          (lib.getExe pkgs.brightnessctl) "--class=backlight" "set" "10%-"
        ];

        # Wheel
        "Mod+WheelScrollDown".action = focus-column-left;
        "Mod+WheelScrollUp".action = focus-column-right;
        "Mod+Ctrl+WheelScrollDown".action = focus-workspace-down;
        "Mod+Ctrl+WheelScrollUp".action = focus-workspace-up;

        # Floating
        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

        # Misc
        "Mod+W".action.spawn = noctaliaMsg "mic-volume-mute";
        "Mod+Escape".action = toggle-keyboard-shortcuts-inhibit;
        "Mod+P".action.spawn = noctaliaMsg "session lock";
        "Mod+Shift+P".action = power-off-monitors;
        "Mod+O".action = toggle-overview;
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        # Session
        "Mod+Shift+E".action = quit;
        "Ctrl+Alt+Delete".action = quit;
      };
    };
  };
}
