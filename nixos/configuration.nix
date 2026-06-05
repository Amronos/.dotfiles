# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  inputs,
  lib,
  options,
  ...
}:

{
  imports = [
    ./cachix.nix
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
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
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  time.timeZone = "Asia/Kolkata";
  networking.timeServers = options.networking.timeServers.default ++ [ "time.windows.com" ];

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  services.hypridle.enable = true;
  programs.hyprlock.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Setup Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Setup printing
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
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

  # Enable sound.
  services.pipewire = {
    alsa.enable = true;
    alsa.support32Bit = true;
    enable = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # Enable touchpad support
  services.libinput.enable = true;

  # Setup power management
  powerManagement.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      START_CHARGE_THRESH_BAT0 = 0;
      STOP_CHARGE_THRESH_BAT0 = 60;
      RESTORE_THRESHOLDS_ON_BAT = 1;
      NATACPI_ENABLE = 1;
      AHCI_RUNTIME_PM_ON_BAT = "on";
    };
  };
  services.logind.settings.Login = {
    IdleAction = "hybrid-sleep";
    IdleActionSec = "30min";
    HandlePowerKey = "ignore";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.amronos = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "audio"
      "dialout"
      "docker"
      "kvm"
      "networkmanager"
      "plugdev"
      "video"
      "wheel"
    ];
  };

  # Define user settings
  nix.settings.trusted-users = [
    "root"
    "amronos"
  ];
  services.udev = {
    packages = [ pkgs.platformio-core.udev ];
    extraRules =
      let
        mkRule = as: lib.concatStringsSep ", " as;
        mkRules = rs: lib.concatStringsSep "\n" rs;
        hdparmRules = mkRules [
          (mkRule [
            ''ACTION=="add|change"''
            ''SUBSYSTEM=="block"''
            ''KERNEL=="sd[a-z]"''
            ''ATTR{queue/rotational}=="1"''
            ''RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 41 /dev/%k"''
          ])
        ];
      in
      ''
        # --- Rules for Luxonis Cameras ---
        SUBSYSTEM=="usb", ATTRS{idVendor}=="03e7", MODE="0666"
        # --- Rules for HDD Power Management ---
        ${hdparmRules}
      '';
  };

  # Home Manager Setup
  home-manager = {
    # Also pass inputs to home-manager modules
    extraSpecialArgs = { inherit inputs; };
    users = {
      "amronos" = import ./home.nix;
    };
  };

  # GPG
  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.gnome.gnome-keyring.enable = true;

  # Automatic Updating
  system.autoUpgrade = {
    dates = "daily";
    enable = false;
    flake = inputs.self.outPath;
    flags = [
      "--print-build-logs"
      "--update-input"
      "nixpkgs"
      "--update-input"
      "home-manager"
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

  # Enable Nix Experimental Features
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allows to run unpatched dynamic binaries
  programs.nix-ld.enable = true;

  # Easily execute appimages
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Needed by nixd
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  programs.direnv.enable = true;

  programs.firefox.enable = true;
  programs.chromium.enable = true;

  # Steam
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;
  # You can add the following in Steam launch options:
  # gamemode run %command%
  # mangohud run %command%
  # gamescope run %command%

  # OBS Studio
  programs.obs-studio.enable = true;
  programs.obs-studio.enableVirtualCamera = true;

  virtualisation.docker.enable = true;

  # Nautilus
  programs.nautilus-open-any-terminal.enable = true;
  services.gvfs.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    android-tools
    arduino-ide
    blender
    boost
    brightnessctl
    cachix
    cairo
    cameractrls
    clang
    clang-tools
    cliphist
    cmake
    code-cursor
    curl
    distrobox
    docker
    docker-buildx
    docker-compose
    docker-gc
    docker-ls
    fastfetch
    ffmpeg
    font-awesome
    freecad
    fuzzel
    gh
    ghostty
    git
    gitbutler
    git-lfs
    google-chrome
    grim
    hyprpaper
    hyprpolkitagent
    hyprshade
    kdePackages.kdenlive
    (kicad.override {
      compressStep = false;
    })
    libglvnd
    libreoffice
    libsForQt5.qt5.qtwayland
    qt5.qtwayland
    llvmPackages.openmp
    luajitPackages.tree-sitter-cli
    mangohud
    mesa
    modrinth-app
    nautilus
    neovim
    nerd-fonts._0xproto
    networkmanagerapplet
    ninja
    nil
    nix-init
    nixd
    nixfmt
    nixpkgs-review
    nodejs
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-lgc-plus
    noto-fonts-monochrome-emoji
    oakctl
    obsidian
    orca-slicer
    pinentry-curses
    pixi
    platformio-core
    powertop
    prismlauncher
    python313
    qemu
    quickemu
    ripgrep
    rpi-imager
    seahorse
    shotwell
    slurp
    stm32cubemx
    swaynotificationcenter
    tree
    usbutils
    unzip
    uv
    vcs2l
    wakatime-cli
    waybar
    wget
    wlogout
    wineWow64Packages.stableFull
    wl-clipboard
    xz
    zed-editor-fhs
    zellij
    zip
    zoom-us
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      font-awesome
      nerd-fonts._0xproto
    ];
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
