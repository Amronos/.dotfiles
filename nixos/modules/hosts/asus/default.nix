{ self, inputs, ... }:
{
  flake.nixosConfigurations.asus = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      self.nixosModules.asusConfiguration
    ];
  };
}
