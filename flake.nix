{
  description = "buglight's home and os config";

  nixConfig = {
    experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # NixOs latest unstable packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The Uncompromising Nix Code Formatter
    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Other non-flake inputs

    my-nvim-config = {
      url = "github:buglight/my-nvim-config/snacks-config";
      flake = false;
    };

    powerlevel10k = {
      url = "github:romkatv/powerlevel10k";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    alejandra,
    ...
  } @ inputs: let
    genSpecialArgs = {system, ...} @ vars:
      inputs
      // {
        inherit vars;

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        alejandra = alejandra.defaultPackage.${system};
      };

    nixosConfig = {
      username,
      hostname,
      system,
      ...
    } @ vars: let
      specialArgs = genSpecialArgs vars;
    in
      nixpkgs.lib.nixosSystem {
        inherit specialArgs system;

        modules = [
          ./hosts/${hostname}/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = import ./hosts/${hostname}/home.nix;
          }
        ];
      };

    homeConfig = {hostname, ...} @ vars: let
      specialArgs = genSpecialArgs vars;
    in
      home-manager.lib.homeManagerConfiguration
      {
        pkgs = specialArgs.pkgs;
        extraSpecialArgs = specialArgs;

        modules = [
          ./hosts/${hostname}/home.nix
        ];
      };
  in {
    nixosConfigurations = {
      liskov =
        nixosConfig
        {
          system = "x86_64-linux";
          username = "buglight";
          hostname = "liskov";
          email = "dmzhukov@outlook.com";
          fullname = "Dani Zhukov";
        };
    };

    homeConfigurations = {
      "zhukovdan@i113734722" =
        homeConfig
        {
          system = "aarch64-darwin";
          username = "zhukovdan";
          hostname = "i113734722";
          email = "dmzhukov@outlook.com";
          fullname = "Dani Zhukov";
        };
    };
  };
}
