{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    authentik-nix.url = "github:nix-community/authentik-nix";
  };
  outputs = {
    self,
    nixpkgs,
    ... 
  }@inputs: {
    nixosModules = rec {
      default = authentik;
      authentik = {
        imports = [
          inputs.authentik-nix.nixosModules.default
        ];

        services.authentik = {
          enable = false; # true;
          # The environmentFile needs to be on the target host!
          # Best use something like sops-nix or agenix to manage it
          # environmentFile = "/run/secrets/authentik/authentik-env";
          settings = {
            email = {
              host = "smtp.example.com";
              port = 587;
              username = "authentik@example.com";
              use_tls = true;
              use_ssl = false;
              from = "authentik@example.com";
            };
            disable_startup_analytics = true;
            avatars = "initials";
          };
        };
      };
      #import ./modules/authentik.nix;
    };

    nixosConfigurations.authentik = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # ../configuration.nix
        self.nixosModules.default
      ];
    };
  };
}
