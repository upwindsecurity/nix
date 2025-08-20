{ lib, stdenv, bash, curl, jq,
  sensorVersion,
  hostconfigVersion,
  region,
  dev,
}:

let
  release = import ./release.nix {
    inherit lib sensorVersion hostconfigVersion region dev;
    system = stdenv.hostPlatform.system;
  };
  srcs =
    [(import ./upwind-artifact.nix {
      inherit stdenv bash curl jq;
      name = release.packages.sensorTarballName;
      artifactUrl = release.packages.sensorTarballUrl;
      artifactHash = release.packages.sensorTarballHash;
      authEndpoint = release.packages.authEndpoint;
      apiEndpoint = release.packages.apiEndpoint;
    }).out]
    ++ lib.optionals (release.packages.hostconfigTarballUrl != null)
    [(import ./upwind-artifact.nix {
      inherit stdenv bash curl jq;
      name = release.packages.hostconfigTarballName;
      artifactUrl = release.package.hostconfigTarballUrl;
      artifactHash = release.package.hostconfigTarballHash;
      authEndpoint = release.packages.authEndpoint;
      apiEndpoint = release.packages.apiEndpoint;
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
