{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    greetd.wlgreet # login screen
  ];

  services.greetd = {
    enable = true;

    settings = rec {
      default_session = {
        command = "sway --config ${./greetd-sway-config}";
        user = "greeter";
      };
    };
  };

  # Enable the gnome-keyring secrets vault.
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;

  # enable Sway window manager
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
