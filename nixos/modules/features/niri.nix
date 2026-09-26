{ inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      self',
      ...
    }:
    let
      noctalia = lib.getExe self'.packages.noctalia;
      ipc = service: action: [
        noctalia
        "ipc"
        "call"
        service
        action
      ];
      workspaceBinds = builtins.listToAttrs (
        builtins.concatMap (
          number:
          let
            index = if number == 0 then 10 else number;
            key = toString number;
          in
          [
            {
              name = "Mod+${key}";
              value.focus-workspace = index;
            }
            {
              name = "Mod+Ctrl+${key}";
              value.move-column-to-workspace = index;
            }
          ]
        ) ([ 0 ] ++ lib.range 1 9)
      );

      # A bind action node with KDL properties applied inline on the key,
      # e.g. Mod+O repeat=false { toggle-overview; }.
      # toKdl only writes `props` when the action value is a function.
      withProps = props: action: _: {
        inherit props;
        content = action;
      };
    in
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          spawn-at-startup = [
            noctalia
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
            (lib.getExe pkgs.udiskie)
            (lib.getExe pkgs.ghostty)
          ];

          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          input.touchpad = {
            tap = _: { };
            natural-scroll = _: { };
          };

          binds = {
            "Mod+Shift+Slash".show-hotkey-overlay = _: { };

            "Mod+T".spawn = lib.getExe pkgs.ghostty;
            "Mod+D".spawn = ipc "launcher" "toggle";
            "Super+Alt+L".spawn = ipc "lockScreen" "lock";

            "Mod+S".spawn = ipc "controlCenter" "toggle";
            "Mod+Shift+Comma".spawn = ipc "settings" "toggle";
            "Mod+Shift+Space".spawn = ipc "launcher" "clipboard";

            "XF86AudioRaiseVolume" = withProps { allow-when-locked = true; } {
              spawn = ipc "volume" "increase";
            };
            "XF86AudioLowerVolume" = withProps { allow-when-locked = true; } {
              spawn = ipc "volume" "decrease";
            };
            "XF86AudioMute" = withProps { allow-when-locked = true; } { spawn = ipc "volume" "muteOutput"; };
            "XF86AudioMicMute" = withProps { allow-when-locked = true; } { spawn = ipc "volume" "muteInput"; };

            "XF86AudioPlay" = withProps { allow-when-locked = true; } { spawn = ipc "media" "playPause"; };
            "XF86AudioPause" = withProps { allow-when-locked = true; } { spawn = ipc "media" "playPause"; };
            "XF86AudioPrev" = withProps { allow-when-locked = true; } { spawn = ipc "media" "previous"; };
            "XF86AudioNext" = withProps { allow-when-locked = true; } { spawn = ipc "media" "next"; };

            "XF86MonBrightnessUp" = withProps { allow-when-locked = true; } {
              spawn = ipc "brightness" "increase";
            };
            "XF86MonBrightnessDown" = withProps { allow-when-locked = true; } {
              spawn = ipc "brightness" "decrease";
            };

            "Mod+O" = withProps { repeat = false; } { toggle-overview = _: { }; };

            "Mod+Q" = withProps { repeat = false; } { close-window = _: { }; };

            "Mod+Left".focus-column-left = _: { };
            "Mod+Down".focus-window-down = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Right".focus-column-right = _: { };
            "Mod+H".focus-column-left = _: { };
            "Mod+J".focus-window-down = _: { };
            "Mod+K".focus-window-up = _: { };
            "Mod+L".focus-column-right = _: { };

            "Mod+Ctrl+Left".move-column-left = _: { };
            "Mod+Ctrl+Down".move-window-down = _: { };
            "Mod+Ctrl+Up".move-window-up = _: { };
            "Mod+Ctrl+Right".move-column-right = _: { };
            "Mod+Ctrl+H".move-column-left = _: { };
            "Mod+Ctrl+J".move-window-down = _: { };
            "Mod+Ctrl+K".move-window-up = _: { };
            "Mod+Ctrl+L".move-column-right = _: { };

            "Mod+Home".focus-column-first = _: { };
            "Mod+End".focus-column-last = _: { };
            "Mod+Ctrl+Home".move-column-to-first = _: { };
            "Mod+Ctrl+End".move-column-to-last = _: { };

            "Mod+Shift+Left".focus-monitor-left = _: { };
            "Mod+Shift+Down".focus-monitor-down = _: { };
            "Mod+Shift+Up".focus-monitor-up = _: { };
            "Mod+Shift+Right".focus-monitor-right = _: { };
            "Mod+Shift+H".focus-monitor-left = _: { };
            "Mod+Shift+J".focus-monitor-down = _: { };
            "Mod+Shift+K".focus-monitor-up = _: { };
            "Mod+Shift+L".focus-monitor-right = _: { };

            "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = _: { };
            "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = _: { };
            "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = _: { };
            "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = _: { };
            "Mod+Shift+Ctrl+H".move-column-to-monitor-left = _: { };
            "Mod+Shift+Ctrl+J".move-column-to-monitor-down = _: { };
            "Mod+Shift+Ctrl+K".move-column-to-monitor-up = _: { };
            "Mod+Shift+Ctrl+L".move-column-to-monitor-right = _: { };

            "Mod+Page_Down".focus-workspace-down = _: { };
            "Mod+Page_Up".focus-workspace-up = _: { };
            "Mod+U".focus-workspace-down = _: { };
            "Mod+I".focus-workspace-up = _: { };
            "Mod+Ctrl+Page_Down".move-column-to-workspace-down = _: { };
            "Mod+Ctrl+Page_Up".move-column-to-workspace-up = _: { };
            "Mod+Ctrl+U".move-column-to-workspace-down = _: { };
            "Mod+Ctrl+I".move-column-to-workspace-up = _: { };

            "Mod+Shift+Page_Down".move-workspace-down = _: { };
            "Mod+Shift+Page_Up".move-workspace-up = _: { };
            "Mod+Shift+U".move-workspace-down = _: { };
            "Mod+Shift+I".move-workspace-up = _: { };

            "Mod+WheelScrollDown" = withProps { cooldown-ms = 150; } { focus-workspace-down = _: { }; };
            "Mod+WheelScrollUp" = withProps { cooldown-ms = 150; } { focus-workspace-up = _: { }; };
            "Mod+Ctrl+WheelScrollDown" = withProps { cooldown-ms = 150; } {
              move-column-to-workspace-down = _: { };
            };
            "Mod+Ctrl+WheelScrollUp" = withProps { cooldown-ms = 150; } {
              move-column-to-workspace-up = _: { };
            };

            "Mod+WheelScrollRight".focus-column-right = _: { };
            "Mod+WheelScrollLeft".focus-column-left = _: { };
            "Mod+Ctrl+WheelScrollRight".move-column-right = _: { };
            "Mod+Ctrl+WheelScrollLeft".move-column-left = _: { };

            "Mod+Shift+WheelScrollDown".focus-column-right = _: { };
            "Mod+Shift+WheelScrollUp".focus-column-left = _: { };
            "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = _: { };
            "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = _: { };

            "Mod+Tab".focus-workspace-previous = _: { };

            "Mod+BracketLeft".consume-or-expel-window-left = _: { };
            "Mod+BracketRight".consume-or-expel-window-right = _: { };
            "Mod+Comma".consume-window-into-column = _: { };
            "Mod+Period".expel-window-from-column = _: { };

            "Mod+R".switch-preset-column-width = _: { };
            "Mod+Shift+R".switch-preset-column-width-back = _: { };
            "Mod+Ctrl+Shift+R".switch-preset-window-height = _: { };
            "Mod+Ctrl+R".reset-window-height = _: { };

            "Mod+F".maximize-column = _: { };
            "Mod+Shift+F".fullscreen-window = _: { };
            "Mod+M".maximize-window-to-edges = _: { };
            "Mod+Ctrl+F".expand-column-to-available-width = _: { };

            "Mod+C".center-column = _: { };
            "Mod+Ctrl+C".center-visible-columns = _: { };

            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            "Mod+V".toggle-window-floating = _: { };
            "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: { };
            "Mod+W".toggle-column-tabbed-display = _: { };

            "Print".screenshot = _: { };
            "Ctrl+Print".screenshot-screen = _: { };
            "Alt+Print".screenshot-window = _: { };

            "Mod+Escape" = withProps { allow-inhibiting = false; } {
              toggle-keyboard-shortcuts-inhibit = _: { };
            };

            "Mod+Shift+E".quit = _: { };
            "Ctrl+Alt+Delete".quit = _: { };
            "Mod+Shift+P".power-off-monitors = _: { };
          }
          // workspaceBinds;
        };
      };
    };
}
