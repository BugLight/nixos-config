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

        theme = "Mellow";

        shell-integration-features = "sudo,ssh-terminfo,ssh-env";
      };
    };

    # Install FiraCode Nerd Font
    home.packages = [
      pkgs.nerd-fonts.fira-code
    ];
    fonts.fontconfig.enable = true;

    terminal.package = ghosttyPackage;
  };
}
