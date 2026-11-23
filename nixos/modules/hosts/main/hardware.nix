{ inputs, ... }:
{
  flake.nixosModules.mainHardware =
    {
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    let
      btrfsSubvolume = subvolume: {
        device = "/dev/mapper/cryptroot";
        fsType = "btrfs";
        options = [
          "subvol=${subvolume}"
          "compress=zstd"
          "noatime"
        ];
      };
    in
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.nixos-hardware.nixosModules.framework-intel-core-ultra-series3
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "sd_mod"
        "thunderbolt"
        "usb_storage"
        "xhci_pci"
      ];
      boot.kernelModules = [ "kvm-intel" ];
      # Framework recommends the non-LTS kernel for Panther Lake.
      boot.kernelPackages = pkgs.linuxPackages_latest;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Partitions are found by the labels set during install, so no UUIDs are needed here.
      boot.initrd.luks.devices.cryptroot = {
        device = "/dev/disk/by-label/cryptroot";
        allowDiscards = true;
      };

      fileSystems."/" = btrfsSubvolume "@root";
      fileSystems."/home" = btrfsSubvolume "@home";
      fileSystems."/nix" = btrfsSubvolume "@nix";
      fileSystems."/swap" = btrfsSubvolume "@swap";
      fileSystems."/boot" = {
        device = "/dev/disk/by-label/BOOT";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      services.btrfs.autoScrub.enable = true;

      # zram has higher priority, so the swapfile only takes overflow.
      zramSwap.enable = true;
      swapDevices = [ { device = "/swap/swapfile"; } ];

      # Panther Lake graphics are only supported by the xe driver.
      hardware.intelgpu.driver = "xe";
      hardware.graphics.enable32Bit = true;

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    };
}
