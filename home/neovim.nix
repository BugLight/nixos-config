{
  pkgs-unstable,
  my-nvim-config,
  ...
}: {
  home.packages = [pkgs-unstable.neovim];

  home.file.my-nvim-config = {
    source = my-nvim-config;
    target = ".config/nvim";
  };

  home.sessionVariables.EDITOR = "nvim";
}
