{ ... }:
{
  flake.nixosModules.sshKeys = {
    # The ecdsa keys mirror https://sshid.io/amronos (Termius devices); update them when that list changes.
    users.users.amronos.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILN+5Sc1fl0TvwLzh4m0xtntO4+ZwkWG3IhGkxR7W/yP amronos@dev-pc"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBKy9uSZe8PbBc6zTjaWpSC0Z3c8PYHZ2QDuPE2o51ac6diBv+XiWZ74ORsDpe3lnpD+4pti+GUXpLBjtdDzvihI= #SSH ID - @amronos"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBAd1yWvQ9dVMYObJcJipeXl/n4aMchcEeH4d/zOrTT9Vg+hqShUSsXKPANRQe/Q1yv9EPH5LVnI8CZpcxlNCrnQ= #SSH ID - @amronos"
    ];
  };
}
