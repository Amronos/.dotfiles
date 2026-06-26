{ self, inputs, ... }:
{
  flake.nixosConfigurations.main = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      self.nixosModules.pikaqConfiguration
    ];
  };
}
