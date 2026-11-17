{
  withSystem,
  inputs,
  lib,
  ...
} @ top: let
  flakeModules = lib.map (m: lib.modules.importApply m top) [
    ./_nixos.nix
    ./_nixpkgs.nix
    ./_home-manager.nix
  ];
in {
  imports =
    [
      inputs.flake-parts.flakeModules.modules
      inputs.flake-parts.flakeModules.flakeModules
    ]
    ++ flakeModules;

  flake.flakeModule = {
    imports = flakeModules;
  };
}
