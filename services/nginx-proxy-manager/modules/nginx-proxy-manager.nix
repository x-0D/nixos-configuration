{ config, modulesPath, pkgs, lib, ... }:
{
  virtualisation.oci-containers.containers.nginx-proxy-manager = {
    image = "jc21/nginx-proxy-manager:latest";
    ports = [ "80:80" "81:81" "443:443" ];
    volumes = [
      "nginx_proxy_mgr_data:/data"
      "nginx_proxy_mgr_letsencrypt:/etc/letsencrypt"
    ];
    autoStart = true;
    extraOptions = [
      "--pull=always"
      "--restart=unless-stopped"
      "--rm=false"
    ];
  };
  networking.firewall.allowedTCPPorts = [ 80 81 443 ];
}