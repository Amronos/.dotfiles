{ ... }:
{
  flake.nixosModules.terminal =
    { pkgs, ... }:
    {
      environment.variables = {
        TERMINAL = "ghostty";
      };

      environment.systemPackages = with pkgs; [
        ghostty
      ];

      programs.bash = {
        enable = true;
        shellAliases = {
          cb = "colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --cmake-args --no-warn-unused-cli";
          cbs = "export MAKEFLAGS='-j 1' && colcon build --parallel-workers=1 --executor sequential --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON";
          os-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/nixos#main --print-build-logs";
          ros-nix-gen = "ros2nix $(find -name package.xml) --nix-ros-overlay github:lopsided98/nix-ros-overlay/master";
          vim = "nvim";
        };
      };
    };
}
