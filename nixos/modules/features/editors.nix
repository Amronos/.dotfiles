{
  ...
}:
{
  flake.nixosModules.editors =
    {
      self,
      lib,
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

      xdg.mime.defaultApplications = lib.genAttrs [
        "application/x-shellscript"
        "text/english"
        "text/plain"
        "text/x-c"
        "text/x-c++"
        "text/x-c++hdr"
        "text/x-c++src"
        "text/x-chdr"
        "text/x-csrc"
        "text/x-java"
        "text/x-makefile"
        "text/x-moc"
        "text/x-pascal"
        "text/x-tcl"
        "text/x-tex"
      ] (_: "dev.zed.Zed.desktop");

      environment.systemPackages = with pkgs; [
        arduino-ide
        blender
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
