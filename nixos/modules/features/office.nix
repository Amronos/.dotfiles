{ ... }:
{
  flake.nixosModules.office =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        libreoffice
        zoom-us
      ];
    };
}
