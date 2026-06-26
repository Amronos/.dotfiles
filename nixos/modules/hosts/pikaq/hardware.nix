{ ... }:
{
  flake.nixosModules.pikaqHardware =
    {
lib,
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/virtualisation/amazon-image.nix")
      ];
  boot.initrd.availableKernelModules = [ "nvme" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f222513b-ded1-49fa-b591-20ce86a2fe7f";
      fsType = "ext4";
    };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
