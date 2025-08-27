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
      default = adguardhome;
      adguardhome = import ./modules/adguardhome.nix;
    };

    nixosConfigurations.adguardhome = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # ../configuration.nix
        self.nixosModules.default
      ];
    };
  };
}
