{
  inputs,
  lib,
  ...
}: {
  flake.modules.nixos.sway = {pkgs, ...}: {
    services.greetd = {
      enable = true;

      settings = rec {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "greeter";
        };
      };
    };

    # Enable the gnome-keyring secrets vault.
    # Will be exposed through DBus to programs willing to store secrets.
    services.gnome.gnome-keyring.enable = true;

    security.polkit.enable = true;

    # enable Sway window manager
    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    home-manager.sharedModules = [inputs.self.modules.homeManager.sway];
  };

  flake.modules.homeManager.sway = {config, pkgs, ...}: {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;

      config = rec {
        defaultWorkspace = "1";
        modifier = "Mod4";

        colors.unfocused = {
          border = "#333333";
          childBorder = "#222222";
          background = "#222222";
          text = "#9a9a9a";
          indicator = "#333333";
        };

        colors.focused = {
          border = "#333333";
          childBorder = "#333333";
          background = "#353535";
          text = "#ffffff";
          indicator = "#333333";
        };

        colors.focusedInactive = {
          border = "#333333";
          childBorder = "#9a9a9a";
          background = "#9a9a9a";
          text = "#ffffff";
          indicator = "#333333";
        };

        gaps.inner = 10;
        gaps.outer = 5;

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
      };
    };

    home.packages = with pkgs; [
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      mako # notification system developed by swaywm maintainer
    ];

    wayland.windowManager.sway.config.terminal = config.terminal.package.meta.mainProgram;
  };
}
