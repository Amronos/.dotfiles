{ ... }:
{
  flake.nixosModules.virtualisation =
    { pkgs, ... }:
    {
      virtualisation.docker.enable = true;

      environment.systemPackages = with pkgs; [
        docker
        docker-buildx
        docker-compose
        docker-gc
        docker-ls
      ];
    };
}
