{
  homeManager,
  nixpkgs,
}: {
  config,
  inputs,
  lib,
  ...
}: let
  homeConfigurations = config.homeConfigurations;
in {
  imports = [
    homeManager.flakeModules.home-manager
  ];

  options.homeConfigurations = lib.options.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
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
        imports = [
          homeConfigurations.${username}
          inputs.self.modules.homeManager.base
        ];
      })
      (lib.filterAttrs (username: _: lib.hasAttr username homeConfigurations)
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

          modules = [
            homeConfig
            inputs.self.modules.homeManager.base
          ];
        };
    in
      lib.mapAttrs mkHomeConfig config.homeConfigurations;
  };
}
