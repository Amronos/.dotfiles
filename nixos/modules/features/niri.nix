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
              name = "Mod+Shift+${key}";
              value.move-column-to-workspace = index;
            }
          ]
        ) ([ 0 ] ++ lib.range 1 9)
      );
    in
    {
      packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          input.touchpad.natural-scroll = _: { };
          outputs."eDP-1".scale = 1.2;
          layout.gaps = 5;
          xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

          spawn-at-startup = [
            noctalia
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
            (lib.getExe pkgs.udiskie)
            (lib.getExe pkgs.ghostty)
          ];

          binds = {
            "Mod+T".spawn = lib.getExe pkgs.ghostty;
            "Mod+K".close-window = _: { };
            "Mod+F".spawn = lib.getExe pkgs.nautilus;
            "Mod+B".spawn = lib.getExe pkgs.firefox;
            "Mod+X".toggle-window-floating = _: { };
            "Mod+S".spawn = ipc "launcher" "toggle";
            "Mod+V".spawn = ipc "launcher" "clipboard";
            "Mod+Comma".spawn = ipc "settings" "toggle";
            "Mod+Space".spawn = ipc "controlCenter" "toggle";
            "Mod+Shift+E".spawn = ipc "sessionMenu" "toggle";
            "Super+Alt+L".spawn = ipc "lockScreen" "lock";
            "Ctrl+Alt+Delete".quit = _: { };

            "Mod+Left".focus-column-left = _: { };
            "Mod+Right".focus-column-right = _: { };
            "Mod+Up".focus-window-up = _: { };
            "Mod+Down".focus-window-down = _: { };
            "Mod+Ctrl+Left".move-column-left = _: { };
            "Mod+Ctrl+Right".move-column-right = _: { };
            "Mod+Ctrl+Up".move-window-up = _: { };
            "Mod+Ctrl+Down".move-window-down = _: { };
            "Mod+WheelScrollDown".focus-workspace-down = _: { };
            "Mod+WheelScrollUp".focus-workspace-up = _: { };

            "XF86AudioRaiseVolume".spawn = ipc "volume" "increase";
            "XF86AudioLowerVolume".spawn = ipc "volume" "decrease";
            "XF86AudioMute".spawn = ipc "volume" "muteOutput";
            "XF86AudioMicMute".spawn = ipc "volume" "muteInput";
            "XF86MonBrightnessUp".spawn = ipc "brightness" "increase";
            "XF86MonBrightnessDown".spawn = ipc "brightness" "decrease";
            "XF86AudioNext".spawn = ipc "media" "next";
            "XF86AudioPause".spawn = ipc "media" "playPause";
            "XF86AudioPlay".spawn = ipc "media" "playPause";
            "XF86AudioPrev".spawn = ipc "media" "previous";
            "Print".screenshot = _: { };
          }
          // workspaceBinds;
        };
      };
    };
}
