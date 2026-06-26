{ ... }:
{
  flake.nixosModules.git =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gh
        git
        gitbutler
        git-lfs
      ];
    };
}
