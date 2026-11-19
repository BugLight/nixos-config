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

  default = {
    imports = [framework];

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

  flake.flakeModules = {
    inherit default framework;
  };
}
