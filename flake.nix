{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    adguardhome.url = "./services/adguardhome";
    # authentik.url = "./services/authentik";
    navidrome.url = "./services/navidrome";
    netdata.url = "./services/netdata";
    nginx-proxy-manager.url = "./services/nginx-proxy-manager";
    portainer.url = "./services/portainer";
    vaultwarden.url = "./services/vaultwarden";
    vscode-server.url = "./services/vscode-server";
    n8n.url = "./services/n8n";
    # services.url = "./services";
  };
  outputs = {
    self,
    nixpkgs,
    # services,
    ... 
  }@inputs: let
    # Initialize modules as an empty list
    modules = let
      svcs = inputs;
    in 
      builtins.map (service: 
      if builtins.hasAttr "outputs" svcs.${service} &&
         builtins.hasAttr "nixosModules" svcs.${service}.outputs &&
         builtins.hasAttr "default" svcs.${service}.outputs.nixosModules then
        svcs.${service}.outputs.nixosModules.default
      else
        null
    ) (builtins.attrNames svcs);
    
    # Filter out null values from modules
    serviceConfigurations = builtins.filter (mod: mod != null) modules;
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
      ] ++ serviceConfigurations;
    };
  };
}
