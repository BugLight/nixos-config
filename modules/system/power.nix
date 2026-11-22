{
  flake.modules.nixos.power = {pkgs, ...}: {
    powerManagement.enable = true;

    # powertop is a power analysis tool
    environment.systemPackages = [pkgs.powertop];

    # Required to expose battery info to dbus interface
    services.upower.enable = true;

    services.tlp = {
      enable = true;

      # Required to expose profiles to dbus initerface
      pd.enable = true;

      settings = {
        CPU_ENERGY_PERF_POLICY_ON_PRF = "performance";
        PLATFORM_PROFILE_ON_AC = "performance";
      };
    };
  };
}
