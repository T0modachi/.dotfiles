{
  config,
  pkgs,
  lib,
  ... 
}:

{
  disko.devices = {
    disk = {
      # Replace 'nvme0n1' with your actual disk name (e.g., 'sda', 'vda')
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "boot";
              size = "512M";
              type = "partition";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                # You might need to add an option like 'boot.loader.efi.efiSysMountPoint = "/boot";' in your configuration.nix
              };
            }
            {
              name = "nixos";
              size = "100%";
              type = "partition";
              content = {
                type = "filesystem";
                format = "ext4"; # Or "btrfs", "f2fs", etc.
                mountpoint = "/";
                # For btrfs, you might want to add subvolumes here
              };
            }
          ];
        };
      };
    };
  };
}
