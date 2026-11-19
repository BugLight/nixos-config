{inputs, ...}: {
  flake.modules.nixos.buglight = {pkgs, ...}: {
    imports = [
      inputs.self.modules.nixos.zsh
    ];

    users.users.buglight = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel" "video" "tss"];
      shell = pkgs.zsh;
    };
  };

  buglight.homeManager.configurations.buglight = {
    imports = with inputs.self.modules.homeManager; [
      cli
      darwin-applications
      desktop-tools
      firefox
      ghostty
      neovim
      nix-garbage-collection
      noctalia
      tmux
      zsh
    ];

    programs.git.settings.user = {
      name = "Dani Zhukov";
      email = "dmzhukov@outlook.com";
    };
  };
}
