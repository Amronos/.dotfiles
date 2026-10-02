{ ... }:
{
  flake.nixosModules.utilities =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        agent-browser
        fastfetch
        tree
        usbutils
        wget
        curl
        jq
        unzip
        zip
        xz
        ripgrep
        vcs2l
      ];
    };
}
