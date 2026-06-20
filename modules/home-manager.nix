{
  config,
  inputs,
  lib,
  ...
} @ top: {
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  options.homeConfigurations = lib.options.mkOption {
    type = lib.types.lazyAttrsOf lib.types.deferredModule;
  };

  config.flake.modules.homeManager.base = {
    pkgs,
    system,
    username,
    ...
  }: let
    isDarwin = lib.strings.hasSuffix "darwin" system;
  in {
    home = {
      # This value determines the home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update home Manager without changing this value. See
      # the home Manager release notes for a list of state version
      # changes in each release.
      stateVersion = "24.11";

      inherit username;
      homeDirectory = let
        homeDirectoryPrefix =
          if isDarwin
          then "/Users"
          else "/home";
      in "${homeDirectoryPrefix}/${username}";

      # Sync applications folder on mac
      activation.rsync-home-manager-applications =
        if isDarwin
        then
          lib.hm.dag.entryAfter ["writeBoundary"] ''
            rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
            apps_source="$genProfilePath/home-path/Applications"
            moniker="Home Manager Trampolines"
            app_target_base="${config.home.homeDirectory}/Applications"
            app_target="$app_target_base/$moniker"
            mkdir -p "$app_target"
            ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
          ''
        else "";
    };

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;
  };

  config.flake.modules.nixos.base = {config, ...}: let
    system = config.nixpkgs.hostPlatform.system;
    homeConfigurations = top.config.homeConfigurations;
  in {
    imports = [inputs.home-manager.nixosModules.home-manager];
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
        inputs.home-manager.lib.homeManagerConfiguration
        {
          pkgs = inputs.nixpkgs.legacyPackages.${system};

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
