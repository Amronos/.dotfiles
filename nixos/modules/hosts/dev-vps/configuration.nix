{ ... }:
{
  flake.nixosModules.devVpsConfiguration =
    { self, pkgs, ... }:
    {
      imports = [
        self.nixosModules.devVpsHardware
        self.nixosModules.nixThings
        self.nixosModules.editorsMinimal
        self.nixosModules.fonts
        self.nixosModules.gitMinimal
        self.nixosModules.languages
        self.nixosModules.sshKeys
        self.nixosModules.tailscale
        self.nixosModules.utilities
        self.nixosModules.virtualisation
      ];

      networking.hostName = "dev-vps";
      time.timeZone = "Asia/Kolkata";

      # SSH is reachable only over Tailscale; the EC2 security group allows no inbound traffic.
      services.openssh = {
        openFirewall = false;
        settings.PasswordAuthentication = false;
      };
      networking.firewall.trustedInterfaces = [ "tailscale0" ];

      users.users.amronos = {
        isNormalUser = true;
        extraGroups = [
          "docker"
          "wheel"
        ];
      };
      security.sudo.wheelNeedsPassword = false;
      nix.settings.trusted-users = [
        "root"
        "amronos"
      ];

      environment.systemPackages = with pkgs; [
        ghostty.terminfo
      ];

      programs.bash = {
        enable = true;
        shellAliases = {
          os-rebuild = "sudo nixos-rebuild switch --flake ~/.dotfiles/nixos#dev-vps --print-build-logs";
          vim = "nvim";
        };
      };

      # See https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion before changing this value.
      system.stateVersion = "26.05"; # Did you read the comment?
    };
}
