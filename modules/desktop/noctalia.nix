{
  inputs,
  lib,
  ...
}: {
  flake.modules.homeManager.noctalia = {
    config,
    pkgs,
    ...
  }: {
    # import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
    ];

    # configure options
    programs.noctalia = {
      enable = true;
      settings = {
        theme = {
          mode = "dark";
          source = "wallpaper";
          wallpaper_scheme = "muted";
        };
        wallpaper = {
          enabled = true;
          default.path = ./sway/wallpaper.png;
        };
      };
    };

    # configure wayland compositor
    wayland.windowManager.sway.config = {
      bars = lib.mkForce [];

      startup = [
        {
          command = "noctalia";
          always = true;
        }
      ];

      keybindings = lib.mkOptionDefault {
        XF86MonBrightnessUp = "exec noctalia msg brightness-up";
        XF86MonBrightnessDown = "exec noctalia msg brightness-down";
        XF86AudioRaiseVolume = "exec noctalia msg volume-up";
        XF86AudioLowerVolume = "exec noctalia msg volume-down";
        XF86AudioMute = "exec noctalia msg volume-mute";
        "Ctrl+Shift+3" = "exec noctalia msg screenshot-fullscreen";
        "Ctrl+Shift+4" = "exec noctalia msg screenshot-region";
      };

      menu = "noctalia msg panel-open launcher";

      window.titlebar = false;
    };
  };
}
