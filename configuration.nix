{ modulesPath, ... }: {
  imports = [
    # Our modules.
    ./system-module.nix
    ./xray-module.nix
  ];
}
