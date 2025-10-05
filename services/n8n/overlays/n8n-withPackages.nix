# TODO: this overlay not tested, need some testing before use
self: super: {
  n8n = super.n8n.overrideAttrs (oldAttrs: {
    passthru = oldAttrs.passthru // {
      withPackages = ps: 
        let
          packages = ps self.nodePackages;
        in
        super.runCommand "n8n-with-packages" {
          nativeBuildInputs = [ super.makeWrapper ];
        } ''
          mkdir -p $out/bin
          makeWrapper ${super.n8n}/bin/n8n $out/bin/n8n \
            --set NODE_PATH ${super.lib.makeSearchPath "lib/node_modules" packages}
        '';
    };
  });

  nodePackages = super.nodePackages // {
    n8n-nodes-datastore = (super.stdenv.mkDerivation rec {
      pname = "n8n-nodes-datastore";
      version = "0.1.18";
      
      src = super.fetchurl {
        url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
        sha256 = "sha256-3Q9N+OVdEhF/gT0kowsWyJDyyd7oVuvQveEfAB8ERrE=";
      };

      buildInputs = [ super.nodejs ];
      
      unpackPhase = ''
        mkdir -p $out/lib/node_modules
        tar -xzf $src -C $out/lib/node_modules
        # Find the extracted directory (it might have a different name)
        extracted_dir=$(find $out/lib/node_modules -maxdepth 1 -type d -name "package" | head -n 1)
        if [ -n "$extracted_dir" ]; then
          mv "$extracted_dir" "$out/lib/node_modules/${pname}"
        fi
      '';

      installPhase = ''
        # Create a symlink to make it available in node_modules
        mkdir -p $out/lib/node_modules
        # The package is already in place from unpackPhase
      '';

      meta = with super.lib; {
        description = "Datastore nodes for n8n";
        homepage = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
        license = licenses.mit; # Adjust based on actual license
        maintainers = with maintainers; [ ]; # Add maintainers if needed
        platforms = platforms.all;
      };
    });
    # Add other community node packages here
  };
}