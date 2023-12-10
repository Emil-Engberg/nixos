{
  description = "My first personal NixOS flake. ";

  inputs = {
    
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {                                                     
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let
    vars = {
      user = "emil";
      location = "/$HOME/.setup";
    };
  in
  {
    nixosConfigurations = (
     import ./host {
        inherit (nixpkgs) lib;
        inherit inputs nixpkgs home-manager vars;
      }
    );
  };
}
