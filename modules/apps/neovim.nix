{withSystem, ...}: {
  flake.modules.homeManager.neovim = {system, ...}: let
    my-nvim-config =
      withSystem system
      ({inputs', ...}: inputs'.my-nvim-config.packages.default);
  in {
    home.packages = [my-nvim-config];

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      extraWrapperArgs = [
        "--set"
        "XDG_CONFIG_HOME"
        "${my-nvim-config}"
        "--set"
        "NVIM_APPNAME"
        "my-nvim-config"
      ];
    };
  };
}
