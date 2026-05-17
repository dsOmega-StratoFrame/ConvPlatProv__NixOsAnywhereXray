{ config, lib, ... }: let
  # STYLE: A bit unclear naming, we store and use here settings not directly
  # related to xray.
  xrayConfig = builtins.fromJSON (builtins.readFile config.xray.configFile);
  readAuthorizedKeys = file: [(builtins.readFile file)];
in {
  imports = [ ./xray-options.nix ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  networking = {
    hostName = "nixos-xray";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        23
        443
        9100
      ];
      allowedUDPPorts = [23];
    };
    interfaces.ens3 = lib.mkIf (xrayConfig.network.gateway != "") {
      useDHCP = false;
      ipv4.addresses = [
        {
          inherit (xrayConfig.network) address;
          inherit (xrayConfig.network) prefixLength;
        }
      ];
    };
    defaultGateway = lib.mkIf (xrayConfig.network.gateway != "") {
      address = xrayConfig.network.gateway;
      interface = "ens3";
    };
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  time.timeZone = "Europe/Zurich";

  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  services.prometheus.exporters.node.enable = xrayConfig.enable_nodeexporter;

  users.users = {
    root = {
      initialPassword = "admin";
      openssh.authorizedKeys.keys = readAuthorizedKeys config.xray.rootAuthorizedKeysFile;
    };
    xray = {
      isNormalUser = true;
      description = "nixos-xray user";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      openssh.authorizedKeys.keys = readAuthorizedKeys config.xray.userAuthorizedKeysFile;
    };
  };

  system.stateVersion = "24.06";
}
