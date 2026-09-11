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
    };
}
