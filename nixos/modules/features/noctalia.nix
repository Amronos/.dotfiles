{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      configDir = "/home/amronos/.dotfiles/noctalia";
    in
    {
      packages.noctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs;
        outOfStoreConfig = configDir;
        settings = {
          general.avatarImage = "${configDir}/avatar.svg";
          wallpaper.directory = "${configDir}/wallpapers";
        };
      };
    };
}
