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
    n8n-nodes-datastore = super.buildNpmPackage rec {
      pname = "n8n-nodes-datastore";
      version = "0.1.18";
      
      src = super.fetchurl {
        url = "https://registry.npmjs.org/${pname}/-/${pname}-${version}.tgz";
        sha256 = "sha256-3Q9N+OVdEhF/gT0kowsWyJDyyd7oVuvQveEfAB8ERrE=";
      };

      # Use a placeholder hash initially
      npmDeps = super.fetchNpmDeps {
        src = src;
        hash = "sha256-usRuCcrW4SziBWhDex2BqJaSXB93rk8ElDMpsAq1vPA=";
        postPatch = ''
          cp ${./npm-pkg-locks/package-lock.json.n8n-nodes-datastore} $out/package-lock.json
        '';

        # Generate a package-lock.json file
        # postPatch = ''
        #   ${pkgs.npm} install --package-lock-only
        # '';

      };
    };
    # Add other community node packages here
  };
}