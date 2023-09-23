{
  description = "Crab rave flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;

        config = {
          allowUnfree = true;
        };
      };

    in
      {
        
        nixosConfigurations = {
          desktop = nixpkgs.lib.nixosSystem {
            specialArgs = { inherit system; };

            modules = [
              ./nixos/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.emil = {
                  home.stateVersion = "22.05";
                  imports =
                    [ (import ./home/home.nix ) ];
                };
                
                # Optionally, use home-manager.extraSpecialArgs to pass
                # arguments to home.nix
              }
            ];
          };
        };
      };
}
