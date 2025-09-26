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
      default = vaultwarden;
      vaultwarden = import ./modules/vaultwarden.nix;
    };

    nixosConfigurations.vaultwarden = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # ../configuration.nix
        self.nixosModules.default
      ];
    };
  };
}
