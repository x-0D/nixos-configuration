{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  };
  outputs = {
    self,
    nixpkgs,
    ... 
  }@inputs: {
    nixosModules = rec {
      default = netdata;
      netdata = import ./modules/netdata.nix;
    };

    nixosConfigurations.netdata = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # ../configuration.nix
        self.nixosModules.default
      ];
    };
  };
}
