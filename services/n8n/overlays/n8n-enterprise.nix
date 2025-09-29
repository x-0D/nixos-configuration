# overlays/n8n-enterprise.nix
final: prev: {
  n8n = prev.n8n.overrideAttrs (finalAttrs: previousAttrs: {
    version = "1.112.6";

    src = final.fetchFromGitHub {
      owner = "x-0D";
      repo = "n8n-enterprise-unlocked";
      rev = "1.112.6";
      # 1.112.0-hash = "sha256-WZSqFphQMucN5cMMPkFKt3c+Y/WTCrxwGNayRg0FlyI=";
      hash = "sha256-z7nFmRRYEj6AHeTwuCEH/N9Oc5tFlEzq5ag20XyD81o=";
    };

    # You already have pnpmDeps, keep that
    pnpmDeps = final.pnpm_10.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      # 1.112.0-hash = "sha256-0kI7YL0d20IOYvMYgJ8TBHFksyviBcpujYIGl6GMmd8=";
      hash = "sha256-0kI7YL0d20IOYvMYgJ8TBHFksyviBcpujYIGl6GMmd8=";
    };

    passthru = previousAttrs.passthru // {
      updateScript = "/dev/null";
    };
  });
}
