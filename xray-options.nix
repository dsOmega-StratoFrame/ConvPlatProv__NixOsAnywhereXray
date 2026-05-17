{ lib, ... }: {
  options.xray = {
    configFile = lib.mkOption {
      type = lib.types.path;
      default = /etc/nixos-xray/xray-config.json;
      description = "Path to the Xray configuration JSON file.";
    };
    rootAuthorizedKeysFile = lib.mkOption {
      type = lib.types.path;
      default = /etc/nixos-xray/root_authorized_keys.txt;
      description = "Path to the root user's authorized keys file.";
    };
    userAuthorizedKeysFile = lib.mkOption {
      type = lib.types.path;
      default = /etc/nixos-xray/authorized_keys.txt;
      description = "Path to the xray user's authorized keys file.";
    };
  };
}
