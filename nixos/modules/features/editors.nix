{
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
      imports = [
        self.nixosModules.editorsMinimal
      ];

      environment.variables = {
        EDITOR = "zeditor";
      };

      environment.systemPackages = with pkgs; [
        arduino-ide
        blender
        code-cursor
        freecad
        (kicad.override {
          compressStep = false;
        })
        obsidian
        stm32cubemx
        zed-editor-fhs
      ];
    };
}
