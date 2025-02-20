{pkgs-unstable, ...}: {
  home.packages = [pkgs-unstable.ghostty];

  home.file.".config/ghostty/config".text = ''
    font-family = FiraCode Nerd Font Mono
    font-size = 16

    theme = mellow

    background-opacity = 0.75
    background-blur = true
  '';

  wayland.windowManager.sway.config.terminal = "ghostty";
}
