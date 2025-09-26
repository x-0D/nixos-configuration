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
      default = n8n;
      n8n = import ./modules/n8n.nix;
    };

    nixosConfigurations.n8n = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # ../configuration.nix
        self.nixosModules.default
      ];
    };
  };
}
