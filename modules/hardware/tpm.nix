{
  flake.modules.nixos.tpm = {pkgs, ...}: {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
      abrmd.enable = true; # Access Broker and Resource Manager Daemon, which exposes access to the TPM chip over dbus
      tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
    };

    environment.systemPackages = [pkgs.tpm2-tools];
  };
}
