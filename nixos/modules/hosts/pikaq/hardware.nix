{ ... }:
{
  flake.nixosModules.pikaqHardware =
    {
      modulesPath,
      ...
    }:

    {
      imports = [
        (modulesPath + "/virtualisation/amazon-image.nix")
      ];
    };
}
