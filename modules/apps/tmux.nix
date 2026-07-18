{
  flake.modules.homeManager.tmux = {
    programs.tmux = {
      enable = true;

      clock24 = true;
      historyLimit = 10000;
      keyMode = "vi";
      mouse = true;
      newSession = true;
      terminal = "tmux-256color";
    };
  };
}

