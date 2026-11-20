{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        alias = {
          co = "checkout";
          st = "status";
        };
        checkout.defaultRemote = "origin";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };
  };
}
