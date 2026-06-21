{
  flake.modules.homeManager.kitty = {pkgs, ...}: {
    programs.kitty = {
      enable = true;

      font = {
        name = "FiraCode Nerd Font Mono";
        size = 16;
      };

      themeFile = "mellow";

      settings = {
        background_opacity = "0.75";
        background_blur = 10;

        macos_quit_when_last_window_closed = true;
      };
    };

    terminal = {
      package = pkgs.kitty;
    };
  };
}
