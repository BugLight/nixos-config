{
  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;

      forwardAgent = true;
    };
  };
}
