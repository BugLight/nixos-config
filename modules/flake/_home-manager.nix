{
  homeManager,
  nixpkgs,
}: {
  config,
  inputs,
  lib,
  ...
}: let
  homeManagerConfigurations = config.framework.homeManager.configurations;
  homeManagerModules = config.framework.homeManager.defaultModules;
in {
  imports = [
    homeManager.flakeModules.home-manager
  ];

  options.framework.homeManager.configurations = lib.options.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
  };

  options.framework.homeManager.defaultModules = lib.options.mkOption {
    type = lib.types.listOf lib.types.deferredModule;
    default = [];
  };

  config.flake.modules.nixos.home-manager = {config, ...}: let
    system = config.nixpkgs.hostPlatform.system;
  in {
    imports = [homeManager.nixosModules.home-manager];
    home-manager.useGlobalPkgs = false;
    home-manager.useUserPackages = false;
    home-manager.extraSpecialArgs = {inherit system;};
    home-manager.users =
      lib.mapAttrs (username: _: {
        _module.args = {inherit username;};
        imports =
          [homeManagerConfigurations.${username}]
          ++ homeManagerModules;
      })
      (lib.filterAttrs (username: _: lib.hasAttr username homeManagerConfigurations)
        config.users.users);
  };

  config.perSystem = {system, ...}: {
    legacyPackages.homeConfigurations = let
      mkHomeConfig = username: homeConfig:
        homeManager.lib.homeManagerConfiguration
        {
          pkgs = nixpkgs.legacyPackages.${system};

          extraSpecialArgs = {
            inherit system username;
          };

          modules =
            [homeConfig]
            ++ homeManagerModules;
        };
    in
      lib.mapAttrs mkHomeConfig config.framework.homeManager.configurations;
  };
}
