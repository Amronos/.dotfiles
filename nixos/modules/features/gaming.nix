{ ... }:
{
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      programs.steam.enable = true;
      programs.steam.gamescopeSession.enable = true;
      programs.gamemode.enable = true;
      # You can add the following in Steam launch options:
      # gamemode run %command%
      # mangohud run %command%
      # gamescope run %command%

      environment.systemPackages = with pkgs; [
        mangohud
        modrinth-app
        prismlauncher
        wineWow64Packages.stableFull
      ];
    };
}
