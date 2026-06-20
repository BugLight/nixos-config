{
  withSystem,
  inputs,
  lib,
  config,
  ...
}: {
  options.nixosConfigurations = lib.options.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
  };

  config.flake.modules.nixos.base = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.11"; # Did you read the comment?
  };

  config.flake.nixosConfigurations = let
    mkNixosConfig = hostname: nixosConfig:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
        };
        modules = [
          nixosConfig
          inputs.self.modules.nixos.base
          ({config, ...}: {
            # Use the configured pkgs from perSystem
            nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system (
              {pkgs, ...}:
              # perSystem module arguments
                pkgs
            );
          })
        ];
      };
  in
    lib.mapAttrs mkNixosConfig config.nixosConfigurations;
}
