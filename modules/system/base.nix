{
  flake.modules.nixos.base = {
    hostname,
    lib,
    ...
  }: {
    networking.hostName = lib.mkDefault hostname;
  };
}
