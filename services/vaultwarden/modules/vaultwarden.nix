{ config, modulesPath, pkgs, lib, ... }:
{
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
    };
  };
  networking.firewall.allowedTCPPorts = [ 8222 ];
}
