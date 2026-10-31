{ ... }:
{
  flake.nixosModules.noctalia = {
    programs.noctalia.enable = true;

    systemd.user.tmpfiles.rules = [
      "d %E/noctalia :0700 - - -"
      "L+ %E/noctalia/config.toml - - - - %h/.dotfiles/noctalia/config.toml"
    ];
  };
}
