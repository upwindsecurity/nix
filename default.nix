{ lib, stdenv, fetchurl, curl, pkgs
, upwindAgentVersion
, upwindAgentSha256_amd64, upwindAgentSha256_arm64
, hostconfigVersion
, hostconfigSha256_amd64, hostconfigSha256_arm64
, upwindAuthEndpoint ? "https://oauth.upwind.dev/oauth/token"
}:

let
  # Determine system architecture
  isX86_64 = stdenv.hostPlatform.system == "x86_64-linux";
  isAarch64 = stdenv.hostPlatform.system == "aarch64-linux";
  
  arch = if isX86_64 then "amd64"
    else if isAarch64 then "arm64"
    else throw "Unsupported platform: ${stdenv.hostPlatform.system}";
  
  # Use the appropriate sha256 based on architecture
  upwindAgentSha256 = if isX86_64 then upwindAgentSha256_amd64
    else if isAarch64 then upwindAgentSha256_arm64
    else throw "No sha256 defined for platform: ${stdenv.hostPlatform.system}";
    
  hostconfigSha256 = if isX86_64 then hostconfigSha256_amd64
    else if isAarch64 then hostconfigSha256_arm64
    else throw "No sha256 defined for platform: ${stdenv.hostPlatform.system}";
in

stdenv.mkDerivation rec {
  pname = "upwind-agent";
  version = upwindAgentVersion;

  srcs = [
    (fetchurl {
      url = "https://releases.upwind.dev/upwind-agent/v${upwindAgentVersion}/upwind-agent-v${upwindAgentVersion}-linux-${arch}.tar.gz";
      sha256 = upwindAgentSha256;
      curlOptsList = [ "--header" "Authorization: Bearer $UPWIND_TOKEN" ];
    })
    (fetchurl {
      url = "https://releases.upwind.dev/upwind-agent-hostconfig/v${hostconfigVersion}/upwind-agent-hostconfig-v${hostconfigVersion}-linux-${arch}.tar.gz";
      sha256 = hostconfigSha256;
      curlOptsList = [ "--header" "Authorization: Bearer $UPWIND_TOKEN" ];
    })
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp upwind-agent $out/bin/
    cp upwind-agent-hostconfig $out/bin/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Upwind Security Agent Components";
    # homepage = "https://docs.upwind.io";
    license = licenses.asl20; # Based on SPDX-License-Identifier: Apache-2.0
    platforms = platforms.linux;
    maintainers = [ maintainers.upwindsecurity ];
  };
}
