{nixpkgs}: {
  config,
  lib,
  ...
}: {
  options.buglight.nixpkgs.config = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = {};
    description = "Configuration passed to the nixpkgs package set.";
  };

  config.perSystem = {system, ...}: {
    _module.args.pkgs = import nixpkgs {
      inherit system;
      config = config.buglight.nixpkgs.config;
    };
  };
}
