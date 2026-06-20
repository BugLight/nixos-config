{
  flake.modules.homeManager.ghostty = {pkgs, ...}: {
    home.packages = [pkgs.ghostty];

    home.file.".config/ghostty/config".text = ''
      font-family = FiraCode Nerd Font Mono
      font-size = 16

      background-opacity = 0.75
      background-blur = true
    '';

    terminal.package = pkgs.ghostty;
  };
}
