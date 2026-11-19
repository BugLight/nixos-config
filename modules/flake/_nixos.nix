{nixpkgs}: {
  config,
  withSystem,
  inputs,
  lib,
  ...
}: {
  options.framework.nixosModules = lib.options.mkOption {
    type = lib.types.listOf lib.types.deferredModule;
    default = [];
  };

  options.nixosConfigurations = lib.options.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
  };

  config.flake.nixosConfigurations = let
    mkNixosConfig = hostname: nixosConfig:
      nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit hostname;
        };
        modules =
          [nixosConfig]
          ++ config.framework.nixosModules
          ++ [
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
