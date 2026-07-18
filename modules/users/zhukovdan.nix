{inputs, ...}: {
  homeConfigurations.zhukovdan = {
    imports = with inputs.self.modules.homeManager; [
      firefox
      ghostty
      neovim
      ssh
      tmux
      zsh
    ];
  };
}
