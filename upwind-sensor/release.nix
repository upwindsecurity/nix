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

  packages = if dev.enable then {
    sensorTarballUrl = dev.sensorTarballUrl;
    sensorTarballHash = dev.sensorTarballHash;
    sensorTarballName = lib.lists.last (lib.strings.splitString "/" dev.sensorTarballUrl);
    
    hostconfigTarballUrl = dev.hostconfigTarballUrl;
    hostconfigTarballHash = dev.hostconfigTarballHash;
    hostconfigTarballName = lib.lists.last (lib.strings.splitString "/" dev.hostconfigTarballUrl);

    authEndpoint = dev.authEndpoint;
    apiEndpoint = dev.apiEndpoint;
  } else let
    sensorSemver = lib.strings.removePrefix "v" (
      if sensorVersion == "stable" then lib.importJSON pathSensorStable else sensorVersion
    );
    sensorTarballName = "upwind-agent-v${sensorSemver}-linux-${arch}.tar.gz";
    sensorManifest = lib.importJSON ../release/upwind-agent/v${sensorSemver}/${sensorTarballName}.json;

    hostconfigSemver = lib.strings.removePrefix "v" (
      if hostconfigVersion == "stable" then lib.importJSON pathHostconfigStable else hostconfigVersion
    );
    hostconfigTarballName = if hostconfigVersion != "" then "upwind-agent-hostconfig-v${hostconfigSemver}-linux-${arch}.tar.gz" else null;
    hostconfigManifest = lib.importJSON ../release/upwind-agent-hostconfig/v${hostconfigSemver}/${hostconfigTarballName}.json;
  in {
    inherit sensorTarballName hostconfigTarballName;
    sensorTarballUrl = "https://${releasesDomain}/upwind-agent/v${sensorSemver}/${sensorTarballName}";
    sensorTarballHash = sensorManifest.sha256;

    hostconfigTarballUrl = if hostconfigVersion != "" then "https://${releasesDomain}/upwind-agent-hostconfig/v${hostconfigSemver}/${hostconfigTarballName}" else null;
    hostconfigTarballHash = if hostconfigVersion != "" then hostconfigManifest.sha256 else null;

    authEndpoint = "https://oauth.${regionDomain}/oauth/token";
    apiEndpoint = "https://agent.${regionDomain}";
  };
}