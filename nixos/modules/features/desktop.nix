{ ... }:
{
  flake.nixosModules.desktop =
    { pkgs, ... }:
    {
      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };
      services.hypridle.enable = true;
      programs.hyprlock.enable = true;
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      programs.nautilus-open-any-terminal.enable = true;
      services.gvfs.enable = true;

      environment.systemPackages = with pkgs; [
        brightnessctl
        cliphist
        fuzzel
        grim
        hyprpaper
        hyprpolkitagent
        hyprshade
        nautilus
        networkmanagerapplet
        qt5.qtwayland
        slurp
        swaynotificationcenter
        waybar
        wl-clipboard
        wlogout
      ];
    };
}
