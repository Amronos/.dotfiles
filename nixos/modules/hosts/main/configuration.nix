{ ... }:
{
  flake.nixosModules.mainConfiguration =
    {
      self,
      config,
      lib,
      pkgs,
      ...
    }:
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

      users.users.amronos.linger = true;

      systemd.user.services.agent-browser-dashboard = {
        description = "Agent Browser dashboard";
        wantedBy = [ "default.target" ];
        unitConfig.ConditionUser = "amronos";
        script = ''
          dashboardHost="$(${config.services.tailscale.package}/bin/tailscale status --json | ${lib.getExe pkgs.jq} -er '.Self.DNSName | select(type == "string" and length > 0) | rtrimstr(".")')"
          exec ${lib.getExe pkgs.agent-browser} dashboard start --port 4848 --allowed-origins "https://$dashboardHost:4848"
        '';
        serviceConfig = {
          Type = "forking";
          PIDFile = "%t/agent-browser/dashboard.pid";
          ExecStartPre = "${lib.getExe pkgs.agent-browser} dashboard stop";
          ExecStop = "${lib.getExe pkgs.agent-browser} dashboard stop";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };

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

      systemd.services.tailscale-serve = {
        description = "Expose local web apps through Tailscale Serve";
        after = [ "tailscaled-set.service" ];
        requires = [ "tailscaled-set.service" ];
        wantedBy = [ "multi-user.target" ];
        script = ''
          ${config.services.tailscale.package}/bin/tailscale serve reset
          ${config.services.tailscale.package}/bin/tailscale serve --bg --yes --https=4321 http://127.0.0.1:4321
          ${config.services.tailscale.package}/bin/tailscale serve --bg --yes --https=5173 http://127.0.0.1:5173
          ${config.services.tailscale.package}/bin/tailscale serve --bg --yes --https=4848 http://127.0.0.1:4848
          ${config.services.tailscale.package}/bin/tailscale serve --bg --yes --https=17731 http://127.0.0.1:17731
        '';
        serviceConfig = {
          Type = "oneshot";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };

      # See https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion before changing this value.
      system.stateVersion = "25.05"; # Did you read the comment?
    };
}
