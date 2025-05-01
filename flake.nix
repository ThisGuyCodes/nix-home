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
      setup = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.thisguy = import ./home.nix;
          }
        ];
        specialArgs = { inherit inputs; };
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Traviss-MacBook-Pro
      darwinConfigurations."Traviss-MacBook-Pro" = setup;
      darwinConfigurations."BL-travis-johnson" = setup;
    };
}
