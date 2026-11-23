{ ... }:
{
  flake.nixosModules.utilities =
    { pkgs, ... }:
    {
      environment.localBinInPath = true;

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
