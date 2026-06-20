{lib, ...}: {
  flake.modules.homeManager.base = {pkgs, ...}: {
    options.terminal = {
      package = lib.mkPackageOption pkgs "terminal" {
        default = ["foot"];
      };
    };
  };
}
