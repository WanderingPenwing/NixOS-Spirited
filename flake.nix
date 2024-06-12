{
  description = "My Ghibli themed nixos config";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = {
    self,
    nixpkgs,
  }: {
    nixosConfigurations = {
      kamaji = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./system/kamaji.nix
          ./system/configuration.nix
        ];
      };

      # add othe config here
    };
  };
}
