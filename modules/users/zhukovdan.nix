{inputs, ...}: {
  buglight.homeManager.configurations.zhukovdan = {
    imports = with inputs.self.modules.homeManager; [
      firefox
      ghostty
      neovim
      nix-garbage-collection
      opencode
      ssh
      tmux
      zsh
    ];
  };
}
