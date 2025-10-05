{ config, modulesPath, pkgs, lib, ... }:
{
  # 1. Disable the original n8n module from nixpkgs
  disabledModules = [ "services/misc/n8n.nix" ];
  imports = [
    ./n8n-service.nix
  ];

  nixpkgs.overlays = [
    (import ../overlays/n8n-enterprise.nix)
    (import ../overlays/n8n-withPackages.nix)
  ];

  environment.systemPackages = [
    pkgs.nodejs # required to install community packages
  ];

  services.n8n = {
    enable = true;
    package = pkgs.n8n.withPackages (ps: [ ps.n8n-nodes-datastore ]);
    # Open firewall for web interface (optional)
    openFirewall = true;
  };

  systemd.services.n8n = {
    environment = {
      N8N_SECURE_COOKIE="false";
      N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE="true";
    };
  };
  networking.firewall.allowedTCPPorts = [ 5678 ];
}
