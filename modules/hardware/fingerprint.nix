{
  flake.modules.nixos.fingerprint = {
    lib,
    pkgs,
    ...
  }: {
    services.fprintd = {
      enable = true;
      tod.enable = true;
      tod.driver = lib.mkDefault pkgs.libfprint-2-tod1-goodix;
    };
  };
}
