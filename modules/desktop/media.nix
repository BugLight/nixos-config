{
  flake.modules.nixos.media = {lib, ...}: {
    security.rtkit.enable = lib.mkDefault true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
