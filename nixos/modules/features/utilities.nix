{ ... }:
{
  flake.nixosModules.utilities =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        curl
        fastfetch
        jq
        ripgrep
        tmux
        tree
        unzip
        usbutils
        vcs2l
        wget
        xz
        zip
      ];
    };
}
