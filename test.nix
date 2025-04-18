# UPWIND_CLIENT_ID=... UPWIND_CLIENT_SECRET=... nix-build ./test.nix
with import <nixpkgs> { };

{
  sensor_tarball = import ./upwind-artifact.nix {
    inherit stdenv bash curl jq;
    upwindIo="upwind.io";
    region="us";
    artifactName="upwind-agent";
    artifactVersion="0.111.0";
    artifactArch="arm64";
    artifactHash="d7c7caf492651d1f502686aa9e5d3fe36b56ae1ce743d541134539e3f75cb9d0";
  };
}
