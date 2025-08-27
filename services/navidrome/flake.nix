{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

  };
  outputs = {
    self,
    nixpkgs,
    ... 
  }@inputs: {
    nixosModules = rec {
      default = navidrome;
      navidrome = import ./modules/navidrome.nix;
    };

    nixosConfigurations.navidrome = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # ../configuration.nix
        self.nixosModules.default
      ];
    };
  };
}
