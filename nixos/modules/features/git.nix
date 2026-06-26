{ ... }:
{
  flake.nixosModules.git =
    { self, pkgs, ... }:
    {
      imports = [
        self.nixosModules.gitMinimal
      ];
      environment.systemPackages = with pkgs; [
        gitbutler
      ];
    };
}
