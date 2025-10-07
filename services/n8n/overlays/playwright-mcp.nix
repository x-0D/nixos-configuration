# SOURCE: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/pl/playwright-mcp/package.nix
final: prev: {
  playwright-mcp = final.buildNpmPackage rec {
    pname = "playwright-mcp";
    version = "0.0.34";

    src = final.fetchFromGitHub {
      owner = "Microsoft";
      repo = "playwright-mcp";
      tag = "v${version}";
      hash = "sha256-SGSzX41D9nOTsGiU16tRFXgarWgePRsNWIcEnNGH0lQ=";
    };

    npmDepsHash = "sha256-+6HmuR1Z5cJkoZq/vsFq6wNsYpZeDS42wwmh3hEgJhM=";

    postInstall = ''
      rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright
      rm -r $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core
      ln -s ${final.playwright-test}/lib/node_modules/playwright $out/lib/node_modules/@playwright/mcp/node_modules/playwright
      ln -s ${final.playwright-test}/lib/node_modules/playwright-core $out/lib/node_modules/@playwright/mcp/node_modules/playwright-core

      wrapProgram $out/bin/mcp-server-playwright \
        --set PLAYWRIGHT_BROWSERS_PATH ${final.playwright-driver.browsers}
    '';

    passthru = {
      # Package and playwright driver versions are tightly coupled.
      skipBulkUpdate = true;
    };

    meta = {
      changelog = "https://github.com/Microsoft/playwright-mcp/releases/tag/v${version}";
      description = "Playwright MCP server";
      homepage = "https://github.com/Microsoft/playwright-mcp";
      license = final.lib.licenses.asl20;
      mainProgram = "mcp-server-playwright";
      maintainers = [ final.lib.maintainers.kalekseev ];
    };
  };
    
}