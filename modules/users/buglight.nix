{inputs, ...}: {
  flake.modules.nixos.buglight = {pkgs, ...}: {
    imports = [
      inputs.self.modules.nixos.zsh
    ];

    users.users.buglight = {
      isNormalUser = true;
      extraGroups = ["networkmanager" "wheel" "video"];
      shell = pkgs.zsh;
    };
  };

  homeConfigurations.buglight = {
    imports = with inputs.self.modules.homeManager; [
      firefox
      ghostty
      neovim
      noctalia
      zsh
    ];
  };
}
