{ config, pkgs, ... }:

{
  home.username = "buglight";
  home.homeDirectory = "/home/buglight";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps

    config = rec {
      modifier = "Mod4";

      terminal = "alacritty"; 

      input.keyboard = {
        xkb_layout = "us,ru(winkeys)";
        xkb_options = "grp:win_space_toggle";
      };

      fonts = {
        names = [ "Noto Sans" ];
        style = "Regular";
        size = 12.0;
      };

      bars = [{
        command = "${pkgs.waybar}/bin/waybar";
        fonts = {
          names = [ "Noto Sans" ];
          style = "Regular";
          size = 12.0;
        };
      }];

      colors = {
        background = "#303446";

        focused.background = "#303446";
        focused.border = "#babbf1";
        focused.childBorder = "#f2d5cf";
        focused.indicator = "#f2d5cf";
        focused.text = "#c6d0f5";

        focusedInactive.background = "#303446";
        focusedInactive.border = "#737994";
        focusedInactive.childBorder = "#f2d5cf";
        focusedInactive.indicator = "#f2d5cf";
        focusedInactive.text = "#c6d0f5";

        unfocused.background = "#303446";
        unfocused.border = "#737994";
        unfocused.childBorder = "#f2d5cf";
        unfocused.indicator = "#f2d5cf";
        unfocused.text = "#c6d0f5";

        urgent.background = "#303446";
        urgent.border = "#ef9f76";
        urgent.childBorder = "#737994";
        urgent.indicator = "#737994";
        urgent.text = "#ef9f76";

        placeholder.background = "#303446";
        placeholder.border = "#737994";
        placeholder.childBorder = "#737994";
        placeholder.indicator = "#737994";
        placeholder.text = "#c6d0f5";
      };
    };
  };

  programs.waybar = {
    enable = true;

    settings.mainBar = {
      modules-left = [ "sway/workspaces" "sway/mode" "sway/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "sway/language" "pulseaudio" "network" "battery" ];

      battery = {
        format = "{capacity}% {icon}";
      };

      clock.format = "{:%a %d.%m.%Y %R}";
    };
  };

  # Packages that should be installed to the user profile.
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

    # networking tools
    dnsutils  # `dig` + `nslookup`
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

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  # basic configuration of git
  programs.git = {
    enable = true;
    userName = "Dani Zhukov";
    userEmail = "dmzhukov@outlook.com";
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 16;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
