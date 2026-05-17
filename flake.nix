{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { nixpkgs, disko, ... }: {
    nixosConfigurations.nixos-anywhere-vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
      ];
    };

    nixosModules = {
      xray-disko = import ./diskio.nix;
      xray-options = import ./xray-options.nix;
      system-module = import ./system-module.nix;
      xray-module = import ./xray-module.nix;
      default = import ./configuration.nix;
    };
  };
}
