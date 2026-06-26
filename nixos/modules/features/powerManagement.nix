{ ... }:
{
  flake.nixosModules.powerManagement =
    { pkgs, ... }:
    {
      powerManagement.enable = true;

      services.tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          AHCI_RUNTIME_PM_ON_BAT = "on";
        };
      };

      services.logind.settings.Login = {
        IdleAction = "hybrid-sleep";
        IdleActionSec = "30min";
        HandlePowerKey = "ignore";
      };

      environment.systemPackages = with pkgs; [
        powertop
      ];
    };
}
