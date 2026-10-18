{ ... }:
{
  flake.nixosModules.nixThings =
    {
      inputs,
      pkgs,
      ...
    }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Allows to run unpatched dynamic binaries
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        libglvnd
        vulkan-loader
        wayland

        # Chrome for Testing, as downloaded by agent-browser
        alsa-lib
        at-spi2-core
        cairo
        cups
        dbus
        expat
        glib
        libgbm
        libx11
        libxcb
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxkbcommon
        libxrandr
        nspr
        nss
        pango
        systemd
      ];
      environment.sessionVariables.XKB_CONFIG_ROOT = "${pkgs.xkeyboard-config}/share/X11/xkb";

      # Easily execute appimages
      programs.appimage = {
        enable = true;
        binfmt = true;
      };

      programs.direnv.enable = true;

      # Automatic Updating
      system.autoUpgrade = {
        dates = "daily";
        enable = false;
        flake = inputs.self.outPath;
        flags = [
          "--print-build-logs"
          "--update-input"
          "nixpkgs"
        ];
        persistent = true;
        runGarbageCollection = true;
        upgrade = true;
      };

      # Automatic Cleanup
      nix.gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 2d";
        persistent = true;

      };
      nix.optimise = {
        automatic = true;
        persistent = true;
      };
      nix.settings.auto-optimise-store = true;

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        nil
        nix-init
        nixd
        nixpkgs-review
      ];
    };
}
