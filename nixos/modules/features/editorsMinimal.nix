{
  inputs,
  ...
}:
{
  flake.nixosModules.editorsMinimal =
    {
      self,
      pkgs,
      ...
    }:
    {
      environment.systemPackages =
        with pkgs;
        with self.packages.${pkgs.stdenv.hostPlatform.system};
        [
          codex
          myNeovim
          wakatime-cli
        ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
        inherit pkgs;
        settings.config_directory = ../../../nvim;
        runtimePkgs = [
          pkgs.luajitPackages.tree-sitter-cli
        ];
      };
    };
}
