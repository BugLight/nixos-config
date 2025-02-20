{vars, ...}: {
  programs.git = {
    enable = true;

    userName = vars.fullname;
    userEmail = vars.email;

    aliases = {
      co = "checkout";
      s = "status";
    };

    extraConfig = {
      checkout.defaultRemote = "origin";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };
}
