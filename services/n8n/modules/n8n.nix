{ config, modulesPath, pkgs, lib, ... }:
{
  nixpkgs.overlays = [
    (import ../overlays/n8n-enterprise.nix)
  ];
  
  services.n8n = {
    enable = true;
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
