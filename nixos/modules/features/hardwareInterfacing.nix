{ ... }:
{
  flake.nixosModules.hardwareInterfacing =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        android-tools
        oakctl
        orca-slicer
        platformio-core
        rpi-imager
      ];

      services.udisks2.enable = true;

      # ros2_control runs its update loop with SCHED_FIFO.
      users.groups.realtime = { };
      users.users.amronos.extraGroups = [ "realtime" ];
      security.pam.loginLimits = [
        {
          domain = "@realtime";
          type = "-";
          item = "rtprio";
          value = "99";
        }
        {
          domain = "@realtime";
          type = "-";
          item = "memlock";
          value = "unlimited";
        }
      ];
    };
}
