{lib, ...}: {
  flake.modules.homeManager.ghostty = {
    pkgs,
    system,
    ...
  }: let
    isDarwin = lib.strings.hasSuffix "darwin" system;
    ghosttyPackage =
      if isDarwin
      then pkgs.ghostty-bin
      else pkgs.ghostty;
  in {
    programs.ghostty = {
      enable = true;
      package = ghosttyPackage;
      settings = {
        background-opacity = 0.75;
        background-blur = true;

        font-family = "FiraCode Nerd Font Mono";
        font-size = 18;

        theme = "mellow";

        shell-integration-features = "sudo,ssh-terminfo,ssh-env";
      };
    };

    terminal.package = ghosttyPackage;
  };
}
