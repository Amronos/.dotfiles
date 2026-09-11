{ ... }:
{
  flake.nixosModules.languages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        bun
        nodejs
        python313
        pixi
        uv
      ];
    };
}
