{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = rec {
      defaultWorkspace = "1";
      modifier = "Mod4";

      input = {
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:win_space_toggle";
        };
      };

      output."*".bg = "${./wallpaper.png} fill";

      fonts = {
        names = ["FiraCode Nerd Font Mono"];
        size = 13.0;
      };

      keybindings = lib.mkOptionDefault {
        XF86MonBrightnessDown = "exec light -U 10";
        XF86MonBrightnessUp = "exec light -A 10";

        XF86AudioRaiseVolume = "exec 'pactl set-sink-volume @DEFAULT_SINK@ +5%'";
        XF86AudioLowerVolume = "exec 'pactl set-sink-volume @DEFAULT_SINK@ -5%'";
        XF86AudioMute = "exec 'pactl set-sink-mute @DEFAULT_SINK@ toggle'";
      };
    };
  };

  home.packages = with pkgs; [
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    mako # notification system developed by swaywm maintainer
  ];
}
