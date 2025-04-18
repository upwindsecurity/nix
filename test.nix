# UPWIND_CLIENT_ID=... UPWIND_CLIENT_SECRET=... nix-build ./test.nix
let
  pkgs = import <nixpkgs>;
in
  {
    sensor_tarball = import ./upwind-artifact.nix {
      upwindArtifactUrl="https://releases.upwind.dev/upwind-agent/v0.111.0/upwind-agent-v0.111.0-linux-arm64.tar.gz";
      upwindArtifactHash="sha256:d7c7caf492651d1f502686aa9e5d3fe36b56ae1ce743d541134539e3f75cb9d0";
      upwindAuthEndpoint="https://oauth.upwind.dev/oauth/token";
      upwindAuthAudience="https://agent.upwind.dev";
    };
  }
