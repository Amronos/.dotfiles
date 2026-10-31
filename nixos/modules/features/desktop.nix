{ ... }:
{
  flake.nixosModules.desktop =
    { pkgs, self, ... }:
    {
      imports = [
        self.nixosModules.noctalia
      ];

      services.xserver.enable = true;
      services.displayManager.gdm.enable = true;
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
      };
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      programs.nautilus-open-any-terminal.enable = true;
      services.gvfs.enable = true;

      environment.systemPackages = [
        pkgs.nautilus
        pkgs.qt5.qtwayland
        pkgs.xwayland-satellite
      ];
    };
}
