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

      systemd.user.tmpfiles.rules = [
        "d %h/.config/zed :0700 - - -"
        "L+ %h/.config/zed/settings.json - - - - %h/.dotfiles/zed/settings.json"
      ];
    };
}
