{ lib, inputs, nixpkgs, home-manager, vars, ... }:

let
  system = "x86_64-linux" ;                               
  lib = nixpkgs.lib;

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

in
{
  nixos-desktop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs vars pkgs;
      host = {
        hostName = "nixos-desktop";
      };
    };
    modules = [
      ./desktop

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit vars inputs;
          host = {
            hostName = "nixos-desktop";
          };
        };
        home-manager.users.${vars.user} = {
          home.stateVersion = "22.05";
          imports = [ 
            (import ./desktop/home.nix) 
          ];
        };
      }
    ];
  };

  nixos-laptop = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs vars lib pkgs;
      host = {
        hostName = "nixos-laptop";
      };
    };
    modules = [
      ./laptop

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit vars;
          host = {
            hostName = "nixos-laptop2";
          };
        };
        home-manager.users.${vars.user} = {
          home.stateVersion = "22.05";
          imports = [ 
            (import ../home/home.nix) 
          ];
        };
      }
    ];
  };
}