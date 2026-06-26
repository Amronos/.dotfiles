{ ... }:
{
  flake.nixosModules.utilities =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        fastfetch
        tree
        usbutils
        wget
        curl
        unzip
        zip
        xz
        ripgrep
        vcs2l
      ];
    };
}
