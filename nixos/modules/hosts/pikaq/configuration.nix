{ ... }:
{
  flake.nixosModules.pikaqConfiguration =
    { self, pkgs, ... }:
    {
      imports = [
        self.nixosModules.pikaqHardware
        self.nixosModules.nixThings
        self.nixosModules.editorsMinimal
        self.nixosModules.fonts
        self.nixosModules.git
        self.nixosModules.languages
        self.nixosModules.security
        self.nixosModules.utilities
        self.nixosModules.virtualisation
      ];

      networking.hostName = "pikaq";

      # See https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion before changing this value.
      system.stateVersion = "26.05"; # Did you read the comment?

      programs.bash = {
        enable = true;
        shellAliases = {
          os-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/nixos#pikaq --print-build-logs";
          vim = "nvim";
        };
      };

      environment.systemPackages = with pkgs; [
        openclaw
      ];
    };
}
