{ ... }:
{
  flake.nixosModules.networking =
    { options, ... }:
    {
      networking.networkmanager.enable = true;
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          5173
          7447
        ];
        allowedUDPPorts = [ 8888 ];
        extraCommands = ''
          iptables -A INPUT -p udp -d 224.0.0.0/4 -j ACCEPT
          iptables -A INPUT -p udp -s 224.0.0.0/4 -j ACCEPT
        '';
      };

      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

      time.timeZone = "Asia/Kolkata";
      networking.timeServers = options.networking.timeServers.default ++ [ "time.windows.com" ];

      i18n.defaultLocale = "en_US.UTF-8";
    };
}
