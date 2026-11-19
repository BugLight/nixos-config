{lib, ...}: {
  flake.modules.homeManager.terminal-interface = {pkgs, ...}: {
    options.terminal = {
      package = lib.mkPackageOption pkgs "terminal" {
        default = ["foot"];
      };
    };
  };
}
