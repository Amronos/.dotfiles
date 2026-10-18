{ ... }:
{
  flake.nixosModules.devVpsHardware =
    { modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/virtualisation/amazon-image.nix")
      ];

      swapDevices = [
        {
          device = "/swapfile";
          size = 8192;
        }
      ];

      nixpkgs.hostPlatform = "x86_64-linux";
    };
}
