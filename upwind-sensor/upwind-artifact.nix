{ stdenv, bash, curl, jq
  , name
  , artifactUrl
  , artifactHash
  , authEndpoint
  , apiEndpoint
}:

stdenv.mkDerivation {
  inherit name artifactUrl authEndpoint apiEndpoint;

  src = ./.;

  impureEnvVars=["UPWIND_AUTH_CLIENT_ID" "UPWIND_AUTH_CLIENT_SECRET"];

  curl = "${curl}/bin/curl";
  jq = "${jq}/bin/jq";
  builder = "${bash}/bin/bash";
  args = [ ./upwind-artifact.sh ];

  outputHashMode = "flat";
  outputHashAlgo = "sha256";
  outputHash = artifactHash;
}
