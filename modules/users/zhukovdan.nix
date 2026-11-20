{inputs, ...}: {
  buglight.homeManager.configurations.zhukovdan = {
    imports = with inputs.self.modules.homeManager; [
      cli
      darwin-applications
      firefox
      ghostty
      neovim
      nix-garbage-collection
      opencode
      ssh
      telegram
      tmux
      zsh
    ];

    programs.git.settings.user = {
      name = "Dani Zhukov";
      email = "dmzhukov@outlook.com";
    };
  };
}
