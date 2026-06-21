{inputs, lib, ...}: {
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
    programs.noctalia-shell = {
      enable = true;
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          dmenu = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 2;
      };
    };

    # configure wayland compositor
    wayland.windowManager.sway.config = {
      bars = lib.mkForce [];
      startup = [
        {command = "noctalia-shell";}
      ];

      menu = let
        noctalia-dmenu = "${config.home.homeDirectory}/.config/noctalia/plugins/dmenu/noctalia-dmenu";
      in ''
        ${pkgs.dmenu}/bin/dmenu_path \
        | ${noctalia-dmenu} \
        | ${pkgs.findutils}/bin/xargs swaymsg exec --
      '';
    };
  };
}
