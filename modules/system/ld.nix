{
  flake.modules.nixos.nix-ld = {pkgs, ...}: {
    # Automatically creates a loader in /lib/* to avoid patching stuff
    # To disable it temporarily use unset NIX_LD
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # List by default
        zlib
        zstd
        stdenv.cc.cc
        curl
        openssl
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd

        # Required
        glib
      ];
    };
  };
}
