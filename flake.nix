{
  description = "Alevsk nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix/release-25.05";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    stylix,
    nix-colors,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    ...
  }: let
    username = "alevsk";
    system = "aarch64-darwin";
  in {
    # Build darwin flake using:
    # $ darwin-rebuild switch --flake .#cloud
    darwinConfigurations."cloud" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [
        ./darwin-configuration.nix

        # Homebrew integration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = username;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
            };
            mutableTaps = false;
            autoMigrate = true;
          };
        }

        # Align homebrew taps config with nix-homebrew
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
      ];
    };

    # Separate Home Manager configuration
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [
        stylix.homeModules.stylix
        nix-colors.homeManagerModules.default
        ./home.nix
      ];
      extraSpecialArgs = {inherit nix-colors;};
    };

    darwinPackages = self.darwinConfigurations."cloud".pkgs;

    # Developer shell with formatting tools
    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
      packages = with nixpkgs.legacyPackages.${system}; [
        alejandra
      ];
      shellHook = ''
        echo "Dev shell: alejandra available (fmt, fmt-check targets in Makefile)."
      '';
    };
  };
}
