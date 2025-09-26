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
  networking.firewall.allowedTCPPorts = [ 5678 ];
}
