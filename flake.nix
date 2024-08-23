{
  description = "My Ghibli themed nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
  }: {
    nixosConfigurations = {
      kamaji = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        specialArgs = {
		  pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        
        modules = [
          ./system/configuration.nix
          ./system/kamaji.nix
		  home-manager.nixosModules.home-manager {
		  	home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.penwing = import ./home/kamaji-home.nix;
		  }
		];
      };
      
      boiler = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";  

        specialArgs = {
		  pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };    
        
        modules = [
          ./system/configuration.nix
          ./system/boiler.nix
        ];
      };
      
      bathhouse = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";  

		specialArgs = {
		  pkgs-unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };  
          
        modules = [
          ./system/configuration.nix
          ./system/bathhouse.nix
        ];
      };
    };
  };
}
