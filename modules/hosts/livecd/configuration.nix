{inputs, ...}: {
  buglight.nixos.configurations.livecd = {modulesPath, ...}: {
    imports = [
      (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
      inputs.self.modules.nixos.firewall-disabled
      inputs.self.modules.nixos.sops
    ];

    nixpkgs.hostPlatform = "x86_64-linux";
  };
}
