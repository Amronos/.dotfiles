{ ... }:
{
  flake.nixosModules.sound =
    { ... }:
    {
      # Enable sound.
      services.pipewire = {
        alsa.enable = true;
        alsa.support32Bit = true;
        enable = true;
        pulse.enable = true;
      };
      security.rtkit.enable = true;

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      services.blueman.enable = true;
    };
}
