{ ... }:
{
  flake.nixosModules.languages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nodejs
        python313
        pixi
        uv
      ];
    };
}
