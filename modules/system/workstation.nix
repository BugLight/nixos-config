{inputs, ...}: {
  flake.modules.nixos.workstation.imports = with inputs.self.modules.nixos; [
    cli-tools
    firewall-disabled
    networkmanager
    nix-maintenance
  ];
}
