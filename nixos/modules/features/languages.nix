{ ... }:
{
  flake.nixosModules.languages =
    { pkgs, ... }:
    {
      environment.sessionVariables.PATH = [ "$HOME/.bun/bin" ];

      environment.systemPackages = with pkgs; [
        bun
        nodejs
        python313
        pixi
        uv
      ];
    };
}
