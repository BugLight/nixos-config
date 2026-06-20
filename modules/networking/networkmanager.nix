{
  flake.modules.nixos.base = {hostname, ...}: {
    networking.hostName = hostname;
    networking.networkmanager.enable = true;
  };
}

