{
  inputs,
  lib,
  ...
}: {
  flake.modules.homeManager.base = {
    config,
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
      sessionPath = ["${config.home.profileDirectory}/bin"];
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
          inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
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
}
