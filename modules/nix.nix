{lib, ...}: let
  nix = {
    # Enable nix flakes support
    settings.experimental-features = ["nix-command" "flakes"];

    # Do garbage collection weekly to keep disk usage low
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };
in {
  flake.modules.nixos.base = {inherit nix;};
  flake.modules.homeManager.base = {inherit nix;};
}
