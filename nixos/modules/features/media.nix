{ ... }:
{
  flake.nixosModules.media =
    { pkgs, ... }:
    {
      programs.obs-studio.enable = true;
      programs.obs-studio.enableVirtualCamera = true;

      environment.systemPackages = with pkgs; [
        cameractrls
        ffmpeg
        kdePackages.kdenlive
        shotwell
      ];
    };
}
