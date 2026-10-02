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
      };
    };
}
