{
  description = "My Ghibli themed nixos config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-unstable,
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
          ./system/kamaji.nix
          ./system/configuration.nix
        ];
      };
    };
  };
}
