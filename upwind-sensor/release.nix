{ 
  lib,
  system,
  sensorVersion,
  hostconfigVersion,
  region,
  dev,
}:

rec {
  pathSensorStable = ../release/upwind-agent/stable.json;
  pathHostconfigStable = ../release/upwind-agent-hostconfig/stable.json;

  regionDomain = if region == "us" then "upwind.io" else "${region}.upwind.io";
  releasesDomain = "releases.${regionDomain}";

  arch = if system == "x86_64-linux" then "amd64"
    else if system == "aarch64-linux" then "arm64"
    else throw "Unsupported platform: ${system}";

  packages = if dev == null then
    let
      sensorSemver = lib.strings.removePrefix "v" (
        if sensorVersion == "stable" then lib.importJSON pathSensorStable else sensorVersion
      );
      sensorTarballName = "upwind-agent-v${sensorSemver}-linux-${arch}.tar.gz";
      sensorManifest = lib.importJSON ../release/upwind-agent/v${sensorSemver}/${sensorTarballName}.json;

      hostconfigSemver = lib.strings.removePrefix "v" (
        if hostconfigVersion == "stable" then lib.importJSON pathHostconfigStable else hostconfigVersion
      );
      hostconfigTarballName = "upwind-agent-hostconfig-v${hostconfigSemver}-linux-${arch}.tar.gz";
      hostconfigManifest = lib.importJSON ../release/upwind-agent-hostconfig/v${hostconfigSemver}/${hostconfigTarballName}.json;
    in {
      inherit sensorTarballName hostconfigTarballName;
      sensorTarballUrl = "https://${releasesDomain}/upwind-agent/v${sensorSemver}/${sensorTarballName}";
      sensorTarballHash = sensorManifest.sha256;

      hostconfigTarballUrl = "https://${releasesDomain}/upwind-agent-hostconfig/v${hostconfigSemver}/${hostconfigTarballName}";
      hostconfigTarballHash = hostconfigManifest.sha256;

      authEndpoint = "https://oauth.${regionDomain}/oauth/token";
      authAudience = "https://agent.${regionDomain}";
  } else {
    sensorTarballUrl = dev.sensorTarballUrl;
    sensorTarballHash = dev.sensorTarballHash;
    sensorTarballName = lib.lists.last (lib.strings.splitString "/" dev.sensorTarballUrl);
    
    hostconfigTarballUrl = dev.hostconfigTarballUrl;
    hostconfigTarballHash = dev.hostconfigTarballHash;
    hostconfigTarballName = lib.lists.last (lib.strings.splitString "/" dev.hostconfigTarballUrl);

    authEndpoint = dev.authEndpoint;
    authAudience = dev.authAudience;
  };
}