{ ... }:
{
  flake.nixosModules.gitMinimal =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        gh
        git
        git-lfs
      ];
    };
}
