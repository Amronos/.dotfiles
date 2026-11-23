{ ... }:
{
  flake.nixosModules.powerManagement =
    { pkgs, ... }:
    {
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      services.logind.settings.Login.HandlePowerKey = "ignore";

      environment.systemPackages = with pkgs; [
        powertop
      ];
    };
}
