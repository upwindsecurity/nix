{ stdenv, bash, curl, jq
, domain
, region
, artifactName
, artifactVersion
, artifactArch
, artifactHash
}:

let
  tarballName = "${artifactName}-v${artifactVersion}-linux-${artifactArch}.tar.gz";
  regionUrl=if region == "us" then domain else "${region}.${domain}"; 
  releaseUrl="https://releases.${regionUrl}";
  artifactUrl="${releaseUrl}/${artifactName}/v${artifactVersion}/${tarballName}";
  authEndpoint="https://oauth.${regionUrl}/oauth/token";
  authAudience="https://agent.${regionUrl}";
in
  stdenv.mkDerivation {
    inherit artifactUrl authEndpoint authAudience;

    name = tarballName;
    src = ./.;

    impureEnvVars=["UPWIND_CLIENT_ID" "UPWIND_CLIENT_SECRET"];

    curl = "${curl}/bin/curl";
    jq = "${jq}/bin/jq";
    builder = "${bash}/bin/bash";
    args = [ ./upwind-artifact.sh ];

    outputHashMode = "flat";
    outputHashAlgo = "sha256";
    outputHash = artifactHash;
  }
