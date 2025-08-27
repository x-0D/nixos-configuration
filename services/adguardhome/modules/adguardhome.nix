{ config, modulesPath, pkgs, lib, ... }:
{
  services.adguardhome = {
    enable = true;
    port = 3000;
    host = 0.0.0.0;
    openFirewall = true;
  };
  services.resolved = {
    # Disable local DNS stub listener on 127.0.0.53
    extraConfig = ''
      DNSStubListener=no
    '';
  };
}
