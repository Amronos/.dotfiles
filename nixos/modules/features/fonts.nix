{ ... }:
{
  flake.nixosModules.fonts =
    { pkgs, ... }:
    {
      fonts = {
        packages = with pkgs; [
          noto-fonts
          noto-fonts-color-emoji
          noto-fonts-lgc-plus
          noto-fonts-monochrome-emoji
          font-awesome
          nerd-fonts._0xproto
        ];
      };
    };
}
