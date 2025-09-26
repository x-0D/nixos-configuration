{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    vscode-server.url = "github:nix-community/nixos-vscode-server";

  };
  outputs = {
    self,
    nixpkgs,
    vscode-server,
    ... 
  }@inputs: {
    nixosModules = rec {
      default = vscode-server;
      vscode-server = {
        imports = [
          inputs.vscode-server.nixosModules.default
        ];
        services.vscode-server.enable = true;
      };
      #import ./modules/vscode-server.nix;
    };

    nixosConfigurations.vscode-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # ../configuration.nix
        self.nixosModules.default
      ];
    };
  };
}
