{inputs, ...}: {
  buglight.homeManager.configurations.zhukovdan = {
    imports = with inputs.self.modules.homeManager; [
      cli
      darwin-applications
      desktop-tools
      firefox
      ghostty
      neovim
      nix-garbage-collection
      opencode
      ssh
      tmux
      zsh
    ];

    programs.git.settings.user = {
      name = "Dani Zhukov";
      email = "dmzhukov@outlook.com";
    };
  };
}
