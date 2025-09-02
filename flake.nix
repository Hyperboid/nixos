#{  outputs = { self, nixpkgs }: {    nixosConfigurations.hyperboid-laptop = nixpkgs.lib.nixosSystem {      system = "x86_64-linux";      modules = [ ./configuration.nix ];    };  };}
{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-2411.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wine.url = "github:nixos/nixpkgs/2c8d3f48d33929642c1c12cd243df4cc7d2ce434";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    nixpkgs,
    nixpkgs-unstable,
    nixpkgs-wine,
    nixpkgs-2411,
    home-manager,
    ...
  }: let
    specialArgs = {
      inputs = inputs;
      unstable = import nixpkgs-unstable {
        config.allowUnfree = true;
        system = "x86_64-linux";
      };
      pkgs-wine = import nixpkgs-wine {
        config.allowUnfree = true;
        system = "x86_64-linux";
      };
      pkgs2411 = nixpkgs-2411.legacyPackages.x86_64-linux;
    };
  in {
    nixosConfigurations = {
      hyperboid-laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./laptop/hardware-configuration.nix
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
      hyperboid-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./desktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hyperboid = import ./laptop/homes/hyperboid.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            networking.hostName = specialArgs.unstable.lib.mkForce "hyperboid-desktop";
          }
        ];
        inherit specialArgs;
      };
      hyperboid-schmesktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common.nix
          ./schmesktop/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hyperboid = import ./laptop/homes/hyperboid.nix;

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
            networking.hostName = specialArgs.unstable.lib.mkForce "hyperboid-schmesktop";
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
