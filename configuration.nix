{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./diskio.nix
    ./system-module.nix
    ./xray-module.nix
  ];
}
