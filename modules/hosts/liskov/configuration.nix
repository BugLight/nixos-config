{inputs, ...}: {
  nixosConfigurations.liskov = {
    imports = with inputs.self.modules.nixos; [
      # Hardware
      ./_hardware.nix
      nvidia

      # Users
      buglight

      # Features
      steam
      sway
    ];
  };
}
