{ inputs, config, modulesPath, pkgs, lib, ... }:
{
  imports = [
    inputs.authentik-nix.nixosModules.default # FIXME: not work
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
}