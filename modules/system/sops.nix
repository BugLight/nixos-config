{inputs, ...}: {
  flake.modules.nixos.sops = {
    hostname,
    lib,
    pkgs,
    ...
  }: {
    imports = [
      inputs.sops-nix.nixosModules.sops
      inputs.self.modules.nixos.tpm
    ];

    system.activationScripts = {
      setupAgeIdentity =
        lib.stringAfter
        ["specialfs"]
        ''
          ${pkgs.coreutils}/bin/install \
            -m 0400 \
            ${../../secrets}/${hostname}/age-identity.txt \
            /run/age-identity.txt
        '';

      setupSecrets.deps = ["setupAgeIdentity"];
    };

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      age = {
        keyFile = "/run/age-identity.txt";
        plugins = [pkgs.age-plugin-tpm];
      };
    };
  };
}
