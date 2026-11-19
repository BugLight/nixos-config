{lib, ...}: {
  flake.modules.nixos.firewall-disabled = {
    networking.firewall.enable = lib.mkDefault false;
  };
}
