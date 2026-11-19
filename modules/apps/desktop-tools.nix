{
  flake.modules.homeManager.desktop-tools = {pkgs, ...}: {
    home.packages = [pkgs.telegram-desktop];
  };
}
