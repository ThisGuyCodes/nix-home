{
  description = "Travis' nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, home-manager, nixpkgs, ... }:
    let
      setup = { tailconfig ? {
        ip = "127.0.0.1";
        name = "";
      }, roles ? [ ], ... }:
        nix-darwin.lib.darwinSystem {
          modules = [
            ./darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.thisguy = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit roles; };
            }
          ];
          specialArgs = {
            inherit inputs;
            inherit roles;
            taildomain = "giraffe-ide.ts.net";
          };
        };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Traviss-MacBook-Pro
      darwinConfigurations."Traviss-MacBook-Pro" = setup {
        roles = [ "ollama" ];
        tailconfig = {
          ip = "100.97.56.50";
          name = "oc";
        };
      };
      darwinConfigurations."BL-travis-johnson" = setup { roles = [ "work" ]; };
    };
}
