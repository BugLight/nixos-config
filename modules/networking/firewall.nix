{lib, ...}: {
  flake.modules.nixos.base = {
    networking.firewall.enable = lib.mkDefault false;
  };
}
