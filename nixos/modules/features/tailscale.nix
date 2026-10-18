{ ... }:
{
  flake.nixosModules.tailscale =
    { config, ... }:
    let
      tailscale = "${config.services.tailscale.package}/bin/tailscale";
    in
    {
      services.tailscale = {
        enable = true;
        extraSetFlags = [
          "--operator=amronos"
          "--ssh"
        ];
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
