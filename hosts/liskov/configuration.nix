{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/nvidia.nix
    ../../modules/steam.nix
    ../../modules/sway
    ../../modules/system.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    prismlauncher
    vesktop
  ];

  hardware.bluetooth.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
