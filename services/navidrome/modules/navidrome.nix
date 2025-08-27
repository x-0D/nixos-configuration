{ config, modulesPath, pkgs, lib, ... }:
{
  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/run/media/navidrome";
    };
    openFirewall = true;
  };
  systemd.tmpfiles.rules = [
    "d /var/lib/navidrome 0744 navidrome navidrome"
    # "d /run/media/navidrome 0666 navidrome navidrome"
  ];
  systemd.tmpfiles.settings = {
    "navidrome" = {
      "/run/media/navidrome".d = { mode = "0666"; user = "navidrome"; group = "navidrome"; };
    };
  };

  # systemd.services.navidrome.after = [ "remote-fs.target" ];
  systemd.services.navidrome.requires = [ "run-media-navidrome.mount" ];
  fileSystems."/run/media/navidrome" = {
    device = "//192.168.1.35/Music/";
    fsType = "cifs";
    options = [
      "x-systemd.automount"
      "auto" #"noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "rw"
    ];
  };
}