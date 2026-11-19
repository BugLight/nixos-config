{
  inputs = {
    buglight.url = "path:../..";
    flake-parts.follows = "buglight/flake-parts";
  };

  outputs = inputs @ {
    buglight,
    flake-parts,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} ({lib, ...}: {
      imports = [
        flake-parts.flakeModules.modules
        buglight.flakeModules.framework
      ];

      systems = ["x86_64-linux"];

      framework.nixos.defaultModules = [inputs.self.modules.nixos.base];
      framework.homeManager.defaultModules = [inputs.self.modules.homeManager.base];

      perSystem = {system, ...}: let
        consumerPkgs = import buglight.inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (_: prev: {
              consumer-marker = prev.writeText "consumer-marker" "";
            })
          ];
        };
      in {
        _module.args.pkgs = lib.mkForce consumerPkgs;

        checks.framework-consumer = let
          nixosConfig = inputs.self.nixosConfigurations.probe.config;
          integratedHome = nixosConfig.home-manager.users.probe;
          standaloneHome = inputs.self.legacyPackages.${system}.homeConfigurations.probe.config;
          systemPackageNames = map (package: package.name) nixosConfig.environment.systemPackages;
        in
          assert builtins.attrNames nixosConfig.home-manager.users == ["probe"];
          assert nixosConfig.environment.sessionVariables.CONSUMER_NIXOS_BASE == "consumer";
          assert builtins.elem "consumer-marker" systemPackageNames;
          assert !integratedHome.programs.git.enable;
          assert integratedHome.home.sessionVariables.CONSUMER_HOME == "consumer";
          assert integratedHome.home.sessionVariables.CONSUMER_HOME_BASE == "consumer";
          assert standaloneHome.home.sessionVariables.CONSUMER_HOME == "consumer";
          assert standaloneHome.home.sessionVariables.CONSUMER_HOME_BASE == "consumer";
            consumerPkgs.writeText "framework-consumer-check" "";
      };

      flake.modules.nixos.base = {
        environment.sessionVariables.CONSUMER_NIXOS_BASE = "consumer";
      };

      flake.modules.homeManager.base = {
        home.sessionVariables.CONSUMER_HOME_BASE = "consumer";
      };

      framework.homeManager.configurations.probe = {
        home = {
          username = "probe";
          homeDirectory = "/home/probe";
          stateVersion = "24.11";
        };

        home.sessionVariables.CONSUMER_HOME = "consumer";
      };

      framework.nixos.configurations.probe = {pkgs, ...}: {
        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "24.11";
        boot.isContainer = true;

        users.users.probe.isNormalUser = true;
        environment.systemPackages = [pkgs.consumer-marker];
      };
    });
}
