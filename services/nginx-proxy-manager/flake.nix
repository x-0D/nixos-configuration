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
      default = nginx-proxy-manager;
      nginx-proxy-manager = import ./modules/nginx-proxy-manager.nix;
    };

    nixosConfigurations.nginx-proxy-manager = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # ../configuration.nix
        self.nixosModules.default
      ];
    };
  };
}
