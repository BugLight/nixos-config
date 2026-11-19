{nixpkgs}: {...}: {
  perSystem = {system, ...}: {
    _module.args.pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    };
  };
}
