{ ... }:
{
  flake.nixosModules.mainConfiguration =
    { self, config, ... }:
    {
      imports = [
        self.nixosModules.mainHardware
        self.nixosModules.nixThings
        self.nixosModules.browsers
        self.nixosModules.desktop
        self.nixosModules.editors
        self.nixosModules.fonts
        self.nixosModules.hardwareInterfacing
        self.nixosModules.gaming
        self.nixosModules.git
        self.nixosModules.languages
        self.nixosModules.media
        self.nixosModules.networking
        self.nixosModules.office
        self.nixosModules.powerManagement
        self.nixosModules.printing
        self.nixosModules.security
        self.nixosModules.sound
        self.nixosModules.terminal
        self.nixosModules.users
        self.nixosModules.utilities
        self.nixosModules.virtualisation
      ];

      networking.hostName = "main";

      services.tailscale.extraSetFlags = [ "--operator=amronos" ];

      systemd.tmpfiles.rules = [
        "d /home/amronos/taildrop 0755 amronos users -"
      ];

      systemd.services.taildrop = {
        description = "Receive Taildrop files";
        after = [ "tailscaled-set.service" ];
        requires = [ "tailscaled-set.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "amronos";
          Group = "users";
          ExecStart = "${config.services.tailscale.package}/bin/tailscale file get --loop --conflict=rename /home/amronos/taildrop";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };

      # See https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion before changing this value.
      system.stateVersion = "25.05"; # Did you read the comment?
    };
}
