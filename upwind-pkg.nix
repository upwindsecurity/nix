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

  sensorSemver = if sensorVersion == "dev" then version_table.dev.sensor
    else if sensorVersion == "stable" then version_table.stable.sensor
    else sensorVersion;

  sensorHash = lib.attrsets.attrByPath [sensorSemver arch] "" version_table.hashes.sensor;

  hostconfigSemver = if hostconfigVersion == "dev" then version_table.dev.hostconfig
    else if hostconfigVersion == "stable" then version_table.stable.hostconfig
    else hostconfigVersion;

  hostconfigHash = lib.attrsets.attrByPath [hostconfigSemver arch] "" version_table.hashes.hostconfig;

  srcs =
    [(import ./upwind-artifact.nix {
      inherit stdenv bash curl jq;
      artifactName = "upwind-agent";
      artifactVersion = sensorSemver;
      artifactArch = arch;
      artifactHash = sensorHash;
      region = region;
      domain = domain;
    }).out]
    ++ lib.optionals (hostconfigVersion != "")
    [(import ./upwind-artifact.nix {
      inherit stdenv bash curl jq;
      artifactName = "upwind-agent-hostconfig";
      artifactVersion = hostconfigSemver;
      artifactArch = arch;
      artifactHash = hostconfigHash;
      region = region;
      domain = domain;
    })];
in

stdenv.mkDerivation rec {
  inherit srcs;

  pname = "upwind";
  version = sensorVersion;

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp upwind-agent $out/bin/upwind-sensor
    cp upwind-agent-hostconfig $out/bin/upwind-sensor-hostconfig 2> /dev/null || true
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
