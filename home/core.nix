{
  config,
  pkgs,
  lib,
  vars,
  ...
}: {
  home = let
    isDarwin = lib.strings.hasSuffix "darwin" vars.system;
    homeDirectoryPrefix =
      if isDarwin
      then "/Users"
      else "/home";
  in {
    username = vars.username;
    homeDirectory = "${homeDirectoryPrefix}/${vars.username}";

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.11";

    # Required home packages
    packages = with pkgs; [
      rsync

      # Home fonts
      (nerdfonts.override {fonts = ["FiraCode"];})
    ];

    # Sync applications folder on mac
    activation.rsync-home-manager-applications =
      if isDarwin
      then
        lib.hm.dag.entryAfter ["writeBoundary"] ''
          rsyncArgs="--archive --checksum --chmod=-w --copy-unsafe-links --delete"
          apps_source="$genProfilePath/home-path/Applications"
          moniker="Home Manager Trampolines"
          app_target_base="${config.home.homeDirectory}/Applications"
          app_target="$app_target_base/$moniker"
          mkdir -p "$app_target"
          ${pkgs.rsync}/bin/rsync $rsyncArgs "$apps_source/" "$app_target"
        ''
      else null;
  };

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
