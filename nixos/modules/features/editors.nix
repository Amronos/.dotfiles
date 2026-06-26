{
  inputs,
  ...
}:
{
  flake.nixosModules.editors =
    {
      self,
      pkgs,
      ...
    }:
    {
      environment.variables = {
        EDITOR = "zeditor";
      };

      environment.systemPackages =
        with pkgs;
        with self.packages.${pkgs.stdenv.hostPlatform.system};
        [
          arduino-ide
          blender
          code-cursor
          codex
          freecad
          (kicad.override {
            compressStep = false;
          })
          myNeovim
          obsidian
          stm32cubemx
          wakatime-cli
          zed-editor-fhs
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
