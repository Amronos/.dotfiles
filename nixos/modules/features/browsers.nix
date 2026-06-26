{ ... }:
{
  flake.nixosModules.browsers =
    { pkgs, ... }:
    {
      programs.firefox.enable = true;
      programs.chromium.enable = true;

      environment.systemPackages = with pkgs; [
        google-chrome
      ];
    };
}
