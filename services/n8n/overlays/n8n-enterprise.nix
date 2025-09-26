# overlays/n8n-enterprise.nix
final: prev: {
  n8n = prev.n8n.overrideAttrs (finalAttrs: previousAttrs: {
    version = "1.112.0";
    
    src = final.fetchFromGitHub {
      owner = "Abdulazizzn";
      repo = "n8n-enterprise-unlocked";
      rev = "master";
      hash = "sha256-WZSqFphQMucN5cMMPkFKt3c+Y/WTCrxwGNayRg0FlyI=";
    };
    
    pnpmDeps = final.pnpm_10.fetchDeps {
      inherit (finalAttrs) pname version src;
      fetcherVersion = 2;
      hash = "sha256-0kI7YL0d20IOYvMYgJ8TBHFksyviBcpujYIGl6GMmd8=";
    };
  });
}