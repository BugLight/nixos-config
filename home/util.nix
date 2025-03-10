{pkgs, ...}: {
  home.packages = with pkgs; [
    neofetch

    # archives
    zip
    xz
    unzip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    fzf # A command-line fuzzy finder
    fd # Simple, fast and user-friendly alternative to find

    # networking tools
    dnsutils # `dig` + `nslookup`
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing

    # misc
    which
    gnused
    gnutar
    gawk
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal
    telegram-desktop

    btop # replacement of htop/nmon
    iftop # network monitoring
  ];
}
