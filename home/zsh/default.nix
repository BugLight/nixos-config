{
  pkgs,
  powerlevel10k,
  ...
}: {
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
        "thefuck"
      ];
    };
  };

  home.packages = [pkgs.thefuck];

  home.file.powerlevel10k-theme = {
    source = powerlevel10k;
    target = ".oh-my-zsh/custom/themes/powerlevel10k";
  };

  home.sessionVariables.SHELL = "zsh";
}
