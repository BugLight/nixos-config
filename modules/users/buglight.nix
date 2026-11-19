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
      firefox
      ghostty
      neovim
      noctalia
      tmux
      zsh
    ];
  };
}
