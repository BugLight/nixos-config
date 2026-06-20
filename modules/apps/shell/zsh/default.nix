{inputs, ...}: {
  flake.modules.nixos.zsh = {
    programs.zsh.enable = true;
  };

  flake.modules.homeManager.zsh = {pkgs, ...}: {
    programs.zsh = {
      enable = true;

      autosuggestion.enable = true;
      enableVteIntegration = true;

      initExtra = ''
        [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
      '';

      oh-my-zsh = {
        enable = true;

        custom = "$HOME/.oh-my-zsh/custom";
        theme = "powerlevel10k/powerlevel10k";

        plugins = [
          "git"
          "sudo"
        ];
      };
    };

    home.file.powerlevel10k-theme = {
      source = inputs.powerlevel10k;
      target = ".oh-my-zsh/custom/themes/powerlevel10k";
    };

    home.sessionVariables.SHELL = "zsh";
  };
}
