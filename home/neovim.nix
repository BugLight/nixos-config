{
  pkgs-unstable,
  my-nvim-config,
  system,
  ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    extraWrapperArgs = [
      "--set"
      "XDG_CONFIG_HOME"
      "${my-nvim-config.outPath}"
      "--set"
      "NVIM_APPNAME"
      "my-nvim-config"
    ];
  };
}
