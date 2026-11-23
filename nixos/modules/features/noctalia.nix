{ ... }:
{
  flake.nixosModules.noctalia = {
    programs.noctalia.enable = true;

    systemd.user.tmpfiles.rules = [
      "d %h/.config/noctalia :0700 - - -"
      "L+ %h/.config/noctalia/config.toml - - - - %h/.dotfiles/noctalia/config.toml"
    ];
  };
}
