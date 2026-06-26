{ ... }:
{
  flake.nixosModules.users =
    { pkgs, ... }:
    {
      # Don't forget to set a password with ‘passwd’.
      users.users.amronos = {
        isNormalUser = true;
        extraGroups = [
          "adbusers"
          "audio"
          "dialout"
          "docker"
          "kvm"
          "networkmanager"
          "plugdev"
          "video"
          "wheel"
        ];
      };

      nix.settings.trusted-users = [
        "root"
        "amronos"
      ];

      services.udev = {
        packages = [ pkgs.platformio-core.udev ];
        extraRules = ''
          # --- Rules for Luxonis Cameras ---
          SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"
        '';
      };
    };
}
