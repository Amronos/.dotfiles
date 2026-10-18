{ self, inputs, ... }:
{
  flake.nixosConfigurations.dev-vps = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs self;
    };
    modules = [
      self.nixosModules.devVpsConfiguration
    ];
  };
}
