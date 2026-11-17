{
  withSystem,
  inputs,
  lib,
  ...
}: {config, ...}: {
  options.nixosConfigurations = lib.options.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
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
