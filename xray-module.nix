{ config, pkgs, ... }: let
  xrayConfig = builtins.fromJSON (builtins.readFile config.xray.configFile);
in {
  imports = [ ./xray-options.nix ];

  environment.systemPackages = with pkgs; [ xray ];

  services.xray = {
    enable = true;
    settings = {
      log = {
        loglevel = xrayConfig.loglevel;
      };

      routing = {
        rules = [];
        domainStrategy = "AsIs";
      };

      inbounds = [
        {
          port = 23;
          tag = "ss";
          protocol = "shadowsocks";
          settings = {
            method = "2022-blake3-aes-128-gcm";
            password = xrayConfig.shadowsocks.password;
            network = "tcp,udp";
          };
        }
        {
          port = 443;
          protocol = "vless";
          tag = "vless_tls";
          settings = {
            clients = xrayConfig.vless.clients;
            # Mandatory for REALITY; VLESS traffic is not encrypted by VLESS
            # intself (the necryption is handled entirely by TLS/REALITY).
            decryption = "none";
          };
          streamSettings = {
            network = "tcp";
            security = "reality";
            realitySettings = {
              show = false;
              dest = xrayConfig.vless.domain + ":443";
              xver = 0;
              serverNames = [xrayConfig.vless.domain];
              privateKey = xrayConfig.vless.privateKey;
              minClientVer = "";
              maxClientVer = "";
              maxTimeDiff = 0;
              shortIds = [xrayConfig.vless.shortId];
            };
          };
          sniffing = {
            enabled = true;
            destOverride = [
              "http"
              "tls"
            ];
          };
        }
      ];

      outbounds = [
        {
          protocol = "freedom";
          tag = "direct";
        }
        {
          protocol = "blackhole";
          tag = "block";
        }
      ];
    };
  };
}
