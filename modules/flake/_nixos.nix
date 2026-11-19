{nixpkgs}: {
  config,
  withSystem,
  inputs,
  lib,
  ...
}: {
  options.nixosConfigurations = lib.options.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
  };

  config.flake.nixosConfigurations = let
    mkNixosConfig = hostname: nixosConfig:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
        };
        modules = [
          nixosConfig
          inputs.self.modules.nixos.base
          inputs.self.modules.nixos.home-manager
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
