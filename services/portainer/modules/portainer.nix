{ config, modulesPath, pkgs, ... }@inputs:
{
    # imports = [
    #   inputs.portainer-on-nixos.nixosModules.portainer
    # ];
    services.portainer = {
    enable = true; # Default false

    version = "latest"; # Default latest, you can check dockerhub for
                        # other tags.

    openFirewall = true; # Default false, set to 'true' if you want
                            # to be able to access via the port on
                            # something other than localhost. 

    port = 9443; # Sets the port number in both the firewall and
                  # the docker container port mapping itself.
  };
}
