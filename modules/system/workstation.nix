{inputs, ...}: {
  flake.modules.nixos.workstation.imports = with inputs.self.modules.nixos; [
    cli-tools
    networkmanager
    nix-garbage-collection
  ];
}
