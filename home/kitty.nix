{...}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "FiraCode Nerd Font Mono";
      size = 16;
    };

    settings = {
      background_opacity = "0.75";
      background_blur = 10;

      macos_quit_when_last_window_closed = true;
    };
  };
}
