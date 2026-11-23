{ ... }:
{
  flake.nixosModules.gitMinimal =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        lfs.enable = true;
        config = {
          init.defaultBranch = "main";
          user = {
            email = "aarav@spikonado.com";
            name = "Aarav Gupta";
          };
        };
      };

      environment.systemPackages = with pkgs; [
        gh
      ];
    };
}
