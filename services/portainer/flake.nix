{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    portainer-on-nixos.url = "gitlab:cbleslie/portainer-on-nixos";
    portainer-on-nixos.inputs.nixpkgs.follows = "nixpkgs";

  };
  outputs = {
    self,
    nixpkgs,
    portainer-on-nixos,
    ... 
  }@inputs: {
    nixosModules = rec {
      default = portainer;
      portainer = {
        imports = [
          inputs.portainer-on-nixos.nixosModules.portainer
          ./modules/portainer.nix
        ];
      };
    };

    nixosConfigurations.portainer = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # ../configuration.nix
        # portainer-on-nixos.nixosModules.portainer # use the module
        self.nixosModules.default
      ];
    };
  };
}
