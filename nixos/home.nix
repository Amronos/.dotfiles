{ ... }:

{
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";

  home.username = "amronos";
  home.homeDirectory = "/home/amronos";

  home.file = {
    ".config/nvim/".source = ../nvim;
    ".config/zed/".source = ../zed;
  };

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
  ];

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "zeditor";
    };
    shellAliases = {
      cb = "colcon build --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON --cmake-args --no-warn-unused-cli";
      cbs = "export MAKEFLAGS='-j 1' && colcon build --parallel-workers=1 --executor sequential --symlink-install --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON";
      os-rebuild = "sudo nixos-rebuild switch --flake $HOME/.dotfiles/nixos#nixos --print-build-logs";
      os-upgrade = "sudo nixos-rebuild switch --flake $HOME/.dotfiles/nixos#nixos --print-build-logs --update-input nixpkgs --update-input home-manager";
      ros-nix-gen = "ros2nix $(find -name package.xml) --nix-ros-overlay github:lopsided98/nix-ros-overlay/master";
      vim = "nvim";
    };
  };
}
