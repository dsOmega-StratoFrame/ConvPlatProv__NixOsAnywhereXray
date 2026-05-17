{ modulesPath, ... }: {
  imports = [
    # Nedeed for initial deployment.
    ./diskio.nix
    (modulesPath + "/installer/scan/not-detected.nix")
    # Our modules.
    ./system-module.nix
    ./xray-module.nix
  ];
}
