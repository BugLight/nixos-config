{inputs, ...}: {
  homeConfigurations.zhukovdan = {
    imports = with inputs.self.modules.homeManager; [
      firefox
      ghostty
      neovim
      zsh
      tmux
    ];
  };
}
