{pkgs, ...}: {
  imports = [
    ../../home/core.nix

    ../../home/alejandra.nix
    ../../home/firefox.nix
    ../../home/git.nix
    ../../home/ghostty.nix
    ../../home/neovim.nix
    ../../home/sway
    ../../home/util.nix
    ../../home/zsh
  ];
}
