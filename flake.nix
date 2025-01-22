#{  outputs = { self, nixpkgs }: {    nixosConfigurations.hyperboid-laptop = nixpkgs.lib.nixosSystem {      system = "x86_64-linux";      modules = [ ./configuration.nix ];    };  };}
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-2411.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-2411,
    home-manager,
    ...
  }: let
    specialArgs = {
      inputs = inputs;
      unstable = nixpkgs-unstable.legacyPackages.x86_64-linux;
      pkgs2411 = nixpkgs-2411.legacyPackages.x86_64-linux;
    };
  in {
    nixosConfigurations = {
      hyperboid-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./laptop/configuration.nix
          ./laptop/gpucompute.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hyperboid = import ./laptop/homes/hyperboid.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
        inherit specialArgs;
      };
      nullanoid-server = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nullanoid/configuration.nix
        ];
        inherit specialArgs;
      };
    };
  };
}
