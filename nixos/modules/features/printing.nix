{ ... }:
{
  flake.nixosModules.printing =
    { pkgs, ... }:
    {
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
        settings.publish = {
          disable-publishing = false;
          publish-addresses = true;
        };
      };

      services.printing = {
        enable = true;
        browsing = true;
        browsedConf = ''
          BrowseDNSSDSubTypes _cups,_print
          BrowseLocalProtocols all
          BrowseRemoteProtocols all
          CreateIPPPrinterQueues All
          BrowseProtocols all
        '';
        drivers = with pkgs; [
          canon-capt
          canon-cups-ufr2
          cups-browsed
          cups-filters
          gutenprint
        ];
      };

      programs.system-config-printer.enable = true;
    };
}
