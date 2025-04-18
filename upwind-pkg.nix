{ lib, stdenv, bash, curl, jq,
  sensorVersion,
  hostconfigVersion,
  region,
  domain,
}:

let
  version_table = import ./upwind-version.nix;

  # Determine system architecture
  isX86_64 = stdenv.hostPlatform.system == "x86_64-linux";
  isAarch64 = stdenv.hostPlatform.system == "aarch64-linux";
  
  arch = if isX86_64 then "amd64"
    else if isAarch64 then "arm64"
    else throw "Unsupported platform: ${stdenv.hostPlatform.system}";

  srcs = [(import ./upwind-artifact.nix {
      inherit stdenv bash curl jq;
      # authUrl = "";
      # artifactUrl = "";
      artifactHash = "";
      region = "";
      upwindIo = "";
      artifactName = "";
      artifactVersion = "";
      artifactArch = "";
    }).out];
in

stdenv.mkDerivation rec {
  inherit srcs;

  pname = "upwind";
  version = sensorVersion;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp upwind-sensor $out/bin/
    cp upwind-sensor-hostconfig $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Upwind Security Sensor Components";
    # homepage = "https://docs.upwind.io";
    license = licenses.asl20; # Based on SPDX-License-Identifier: Apache-2.0
    platforms = platforms.linux;
    maintainers = [ maintainers.upwindsecurity ];
  };
}
