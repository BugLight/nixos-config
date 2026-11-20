{homeManager}: {
  config,
  inputs,
  lib,
  withSystem,
  ...
}: let
  homeManagerConfigurations = config.buglight.homeManager.configurations;
  homeManagerModules = config.buglight.homeManager.defaultModules;
in {
  imports = [
    homeManager.flakeModules.home-manager
  ];

  options.buglight.homeManager.configurations = lib.options.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
  };

  options.buglight.homeManager.defaultModules = lib.options.mkOption {
    type = lib.types.listOf lib.types.deferredModule;
    default = [];
  };

  config.flake.modules.nixos.home-manager = {config, ...}: let
    system = config.nixpkgs.hostPlatform.system;
  in {
    imports = [homeManager.nixosModules.home-manager];
    home-manager.useGlobalPkgs = true;
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
          pkgs = withSystem system ({pkgs, ...}: pkgs);

          extraSpecialArgs = {
            inherit system username;
          };

          modules =
            [homeConfig]
            ++ homeManagerModules;
        };
    in
      lib.mapAttrs mkHomeConfig config.buglight.homeManager.configurations;
  };
}
