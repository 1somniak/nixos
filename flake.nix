{
  inputs = {
    # 25.11
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      # home manager version = system version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets Wi-Fi (fichier local non-flake)
    wifi = {
      url = "path:/etc/nixos/wifi.nix";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
    };
  };
}
