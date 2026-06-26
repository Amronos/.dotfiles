{ ... }:
{
  flake.nixosModules.security =
    { pkgs, ... }:
    {
      services.pcscd.enable = true;
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      services.gnome.gnome-keyring.enable = true;

      environment.systemPackages = with pkgs; [
        pinentry-curses
        seahorse
        yubioath-flutter
        yubikey-manager
        yubico-pam
        yubikey-personalization
        yubico-piv-tool
        yubihsm-setup
        yubihsm-shell
      ];
    };
}
