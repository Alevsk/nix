{
  description = "Alevsk nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # Override brew-src to a newer Homebrew version (older pins can't parse newer formulas/casks).
    # Must track upstream Homebrew: the cask JSON API (used in API mode) emits new DSL
    # stanzas as they ship, and an older brew core throws "undefined method '<stanza>'".
    # 2026-07-29: bumped 5.1.15 -> 6.0.13; the `firefox` cask started using the
    # `command_wrapper` artifact (Homebrew/brew#23183), which 6.0.1 does not implement.
    nix-homebrew.inputs.brew-src.url = "github:Homebrew/brew/6.0.13";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-typewhisper = {
      url = "github:typewhisper/homebrew-tap";
      flake = false;
    };
    gentleman-programming-tap = {
      url = "github:gentleman-programming/homebrew-tap";
      flake = false;
    };
    higgsfield-ai-tap = {
      url = "github:higgsfield-ai/homebrew-tap";
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
    homebrew-typewhisper,
    gentleman-programming-tap,
    higgsfield-ai-tap,
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

        # Overlay: fix ast-grep build (test_scan_invalid_rule_id fails in sandbox)
        {
          nixpkgs.overlays = [
            (final: prev: {
              ast-grep = prev.ast-grep.overrideAttrs (old: {
                doCheck = false;
              });
            })
          ];
        }

        # Homebrew integration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = username;
            # Taps are intentionally NOT provided via Nix:
            #   - homebrew/homebrew-core and homebrew/homebrew-cask are served by brew's
            #     JSON API and don't need a local tap.
            #   - Third-party taps need a real .git checkout, but `flake = false` inputs
            #     don't carry .git, so nix-homebrew can't materialize them as real taps
            #     (Homebrew 5.1.15+ rejects symlink-only taps; see nix-darwin #1791).
            # The third-party taps are declared via `homebrew.taps` so brew taps them
            # natively during activation.
            taps = {};
            mutableTaps = true;
            autoMigrate = true;
          };
        }

        # Third-party Homebrew taps (brew taps these on activation)
        {
          homebrew.taps = [
            "alevsk/tap"
            "gentleman-programming/tap"
            "higgsfield-ai/tap"
            "rjyo/moshi"
            "typewhisper/tap"
          ];
        }
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
