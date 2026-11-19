{
  flake.modules.nixos.networkmanager = {
    networking.networkmanager.enable = true;
  };

  flake.modules.nixos.sops = {config, ...}: {
    sops.secrets.wifi = {
      restartUnits = ["NetworkManager.service"];
    };

    networking.networkmanager.ensureProfiles = {
      environmentFiles = [
        config.sops.secrets.wifi.path
      ];

      profiles = {
        Household5G = {
          connection = {
            id = "Household5G";
            interface-name = "wlo1";
            type = "wifi";
            uuid = "81211a57-647a-41ab-a956-40ab0ae3462c";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = {};
          wifi = {
            mode = "infrastructure";
            ssid = "Household5G";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$Household5G_PSK";
          };
        };
      };
    };
  };
}
