{inputs, ...}: {
  nixosConfigurations.liskov = {
    imports = with inputs.self.modules.nixos; [
      # Hardware
      ./_hardware.nix
      nvidia

      # Users
      buglight

      # Features
      secure-boot
      steam
      sway
      tpm
    ];

    custom.secureBoot.enable = true;
  };
}
