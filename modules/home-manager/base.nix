{lib, ...}: {
  flake.modules.homeManager.base = {
    config,
    pkgs,
    system,
    username,
    ...
  }: let
    isDarwin = lib.strings.hasSuffix "darwin" system;
  in {
    options.terminal.package = lib.mkPackageOption pkgs "terminal" {
      default = ["foot"];
    };

    config = {
      home = {
        # This value determines the home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update home Manager without changing this value. See
        # the home Manager release notes for a list of state version
        # changes in each release.
        stateVersion = lib.mkDefault "24.11";

        inherit username;
        sessionPath = ["${config.home.profileDirectory}/bin"];
        homeDirectory = let
          homeDirectoryPrefix =
            if isDarwin
            then "/Users"
            else "/home";
        in "${homeDirectoryPrefix}/${username}";
      };

      # Let home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };
}
