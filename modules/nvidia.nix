{
  config,
  pkgs,
  ...
}: {
  hardware.graphics.enable = true;
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Use proprietary driver
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;

    nvidiaSettings = true;

    # Setup PRIME
    prime = {
      # Offload mode: discrete GPU used for specific tasks only
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  services.xserver.videoDrivers = ["nvidia"];
}
