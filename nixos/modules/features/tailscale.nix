{ ... }:
{
  flake.nixosModules.tailscale =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      tailscale = "${config.services.tailscale.package}/bin/tailscale";
    in
    {
      services.tailscale = {
        enable = true;
        extraSetFlags = [ "--operator=amronos" ];
      };

      users.users.amronos.linger = true;

      systemd.user.services.agent-browser-dashboard = {
        description = "Agent Browser dashboard";
        wantedBy = [ "default.target" ];
        unitConfig.ConditionUser = "amronos";
        script = ''
          dashboardHost="$(${tailscale} status --json | ${lib.getExe pkgs.jq} -er '.Self.DNSName | select(type == "string" and length > 0) | rtrimstr(".")')"
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
          ExecStart = "${tailscale} file get --loop --conflict=rename /home/amronos/taildrop";
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
          ${tailscale} serve reset
          ${tailscale} serve --bg --yes --https=4321 http://127.0.0.1:4321
          ${tailscale} serve --bg --yes --https=5173 http://127.0.0.1:5173
          ${tailscale} serve --bg --yes --https=4848 http://127.0.0.1:4848
          ${tailscale} serve --bg --yes --https=17731 http://127.0.0.1:17731
        '';
        serviceConfig = {
          Type = "oneshot";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
}
