{ ... }:
{
  flake.nixosModules.asusConfiguration =
    { self, ... }:
    {
      imports = [
        self.nixosModules.asusHardware
        self.nixosModules.nixThings
        self.nixosModules.browsers
        self.nixosModules.desktop
        self.nixosModules.editorsMinimal
        self.nixosModules.fonts
        self.nixosModules.gitMinimal
        self.nixosModules.languages
        self.nixosModules.networking
        self.nixosModules.powerManagement
        self.nixosModules.security
        self.nixosModules.sound
        self.nixosModules.tailscale
        self.nixosModules.terminal
        self.nixosModules.users
        self.nixosModules.utilities
        self.nixosModules.virtualisation
      ];

      networking.hostName = "asus";

      # See https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion before changing this value.
      system.stateVersion = "25.05"; # Did you read the comment?
    };
}
