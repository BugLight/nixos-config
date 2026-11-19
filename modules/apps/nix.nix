{lib, ...}: let
  nixModule = {pkgs, ...}: {
    nix.package = lib.mkDefault pkgs.nix;

    # Enable nix flakes support
    nix.settings.experimental-features = ["nix-command" "flakes"];
  };

  nixGarbageCollectionModule = {
    # Do garbage collection weekly to keep disk usage low
    nix.gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 7d";
    };
  };
in {
  flake.modules.nixos.base = nixModule;
  flake.modules.nixos.nix-garbage-collection = nixGarbageCollectionModule;
  flake.modules.homeManager.base = nixModule;
  flake.modules.homeManager.nix-garbage-collection = nixGarbageCollectionModule;
}
