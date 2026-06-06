{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    nixpkgs,
    disko,
    ...
  }: {
    nixosConfigurations.nixos-anywhere-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
      ];
    };

    nixosModules = {
      # For deploy-rs, NixOS only needs the **result** of the disk setup (what's mounted where, where GRUB installs), not the **process** of creating it. That's exactly:
      xray-disko = {
        fileSystems."/" = {
          device = "/dev/pool/root";
          fsType = "ext4";
        };
        fileSystems."/boot" = {
          device = "/dev/disk/by-partlabel/disk-disk1-ESP";
          fsType = "vfat";
        };
        boot.loader.grub.devices = ["/dev/vda"];
      };
      xray-options = import ./xray-options.nix;
      system-module = import ./system-module.nix;
      xray-module = import ./xray-module.nix;
      default = import ./configuration.nix;
    };
  };
}
