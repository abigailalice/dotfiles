
# sudo ln -s <this-file> /etc/nixos/flake.nix

{
  inputs = {
    # previously was https://nixos.org/channels/nixos-22.11
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs , home-manager }: {
    # replace 'nixos' with your hostname here, as given by '$ hostname'
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # imports = [
      #   ./hardware-configuration-mini.nix
      # ];
      modules = [
        ./configuration.nix
        ./hardware-configuration-mini.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.abigailgooding = import ./home.nix;
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}

