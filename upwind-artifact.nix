{ upwindArtifactUrl
, upwindArtifactHash
, upwindAuthEndpoint
, upwindAuthAudience }:

let
  pkgs = import <nixpkgs> {};
in
  pkgs.stdenv.mkDerivation {
    name = "upwind-artifact";

    src = ./.;

    CURL = "${pkgs.curl}/bin/curl";
    JQ = "${pkgs.jq}/bin/jq";

    UPWIND_AUTH_ENDPOINT = upwindAuthEndpoint;
    UPWIND_ARTIFACT_URL = upwindArtifactUrl;
    UPWIND_AUTH_AUDIENCE = upwindAuthAudience;
    impureEnvVars=["UPWIND_CLIENT_ID" "UPWIND_CLIENT_SECRET"];

    builder = "${pkgs.bash}/bin/bash";
    args = [ ./upwind-artifact.sh ];

    outputHashMode = "flat";
    outputHash = upwindArtifactHash;
  }
