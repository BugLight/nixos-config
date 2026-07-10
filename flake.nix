{
  description = "buglight's home and os config";

  inputs = {
    # NixOS official package source, using the unstable branch
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Flake-parts modular framework
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Recursively import Nix modules from a directory
    import-tree = {
      url = "github:denful/import-tree";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # A beautiful, minimal desktop shell for Wayland
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The Uncompromising Nix Code Formatter
    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    my-nvim-config = {
      url = "github:buglight/my-nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other non-flake inputs

    powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;}
    (inputs.import-tree ./modules);
}
