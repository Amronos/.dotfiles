{ ... }:
{
  flake.nixosModules.pikaqConfiguration =
    { self, ... }:
    {
      imports = [
        self.nixosModules.pikaqHardware
        self.nixosModules.nixThings
        self.nixosModules.editors
        self.nixosModules.fonts
        self.nixosModules.git
        self.nixosModules.languages
        self.nixosModules.security
        self.nixosModules.terminal
        self.nixosModules.utilities
        self.nixosModules.virtualisation
      ];

      networking.hostName = "pikaq";

      # See https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion before changing this value.
      system.stateVersion = "26.05"; # Did you read the comment?
    };
}
