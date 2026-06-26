{ self, inputs, ... }:
{
  flake.nixosConfigurations.pikaq = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      self.nixosModules.pikaqConfiguration
    ];
  };
}
