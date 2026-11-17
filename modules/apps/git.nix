{
  flake.modules.homeManager.base = {
    programs.git = {
      enable = true;
      userName = "Dani Zhukov";
      userEmail = "dmzhukov@outlook.com";

      aliases = {
        co = "checkout";
        st = "status";
      };

      extraConfig = {
        checkout.defaultRemote = "origin";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
      };
    };
  };
}
