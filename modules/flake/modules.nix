{
  config,
  inputs,
  lib,
  ...
}: let
  frameworkModules = [
    (lib.modules.importApply ./_nixos.nix {
      nixpkgs = inputs.nixpkgs;
    })
    (lib.modules.importApply ./_nixpkgs.nix {
      nixpkgs = inputs.nixpkgs;
    })
    (lib.modules.importApply ./_home-manager.nix {
      homeManager = inputs.home-manager;
      nixpkgs = inputs.nixpkgs;
    })
  ];

  framework = {
    imports = frameworkModules;
  };

  default = {inputs, ...}: {
    imports = [framework];

    framework.nixos.defaultModules = [inputs.self.modules.nixos.base];
    framework.homeManager.defaultModules = [inputs.self.modules.homeManager.base];

    flake.modules.nixos.base.imports = [config.flake.modules.nixos.base];
    flake.modules.homeManager.base.imports = [config.flake.modules.homeManager.base];
  };
in {
  imports =
    [
      inputs.flake-parts.flakeModules.modules
      inputs.flake-parts.flakeModules.flakeModules
    ]
    ++ frameworkModules;

  framework.nixos.defaultModules = [config.flake.modules.nixos.base];
  framework.homeManager.defaultModules = [config.flake.modules.homeManager.base];

  flake.flakeModules = {
    inherit default framework;
  };
}
