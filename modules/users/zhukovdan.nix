{inputs, ...}: {
  homeConfigurations.zhukovdan = {
    imports = with inputs.self.modules.homeManager; [
      firefox
      kitty
      neovim
    ];
  };
}
