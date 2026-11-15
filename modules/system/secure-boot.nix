{inputs, ...}: {
  flake.modules.nixos.secure-boot = {
    config,
    pkgs,
    lib,
    ...
  }: let
    cfg = config.custom.secureBoot;
  in {
    imports = [inputs.lanzaboote.nixosModules.lanzaboote];

    options.custom.secureBoot = {
      enable = lib.mkEnableOption "Secure boot";

      pkiPath = lib.options.mkOption {
        type = lib.types.path;
        default = "/var/lib/sbctl";
      };
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [
        # For debugging and troubleshooting Secure Boot.
        pkgs.sbctl
      ];

      # Lanzaboote currently replaces the systemd-boot module.
      # This setting is usually set to true in configuration.nix
      # generated at installation time. So we force it to false
      # for now.
      boot.loader.systemd-boot.enable = lib.mkForce false;

      boot.lanzaboote = {
        enable = true;
        pkiBundle = cfg.pkiPath;

        autoEnrollKeys = {
          enable = true;
          includeFirmwareBuiltinKeys = true;
          autoReboot = true;
        };
      };
    };
  };
}
