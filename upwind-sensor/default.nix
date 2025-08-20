{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.upwindSensor;
  upwindPkg = pkgs.callPackage ./upwind-pkg.nix {
    sensorVersion = cfg.sensorVersion;
    hostconfigVersion = if cfg.enableHostconfig then cfg.hostconfigVersion else "";
    region = cfg.region;
    dev = cfg.dev;
  };
  coerceToString = x:
    if builtins.isBool x then
      if x then "true" else "false"
    else builtins.toString x;
  extraConfigKeys = lib.attrsets.attrNames cfg.extraConfig;
  extraConfigValues = lib.lists.forEach (lib.attrsets.attrValues cfg.extraConfig) coerceToString;
  extraConfigString = lib.strings.concatLines (
    lib.lists.zipListsWith (key: value: "${key}: \"${value}\"") extraConfigKeys extraConfigValues
  );
  apiEndpoint = if cfg.dev.enable then cfg.dev.apiEndpoint else "https://agent${if cfg.region != "us" then ".${cfg.region}" else ""}.upwind.io";
  authEndpoint = if cfg.dev.enable then cfg.dev.authEndpoint else "https://oauth${if cfg.region != "us" then ".${cfg.region}" else ""}.upwind.io/oauth/token";
in
{
  options.services.upwindSensor = {
    enable = mkEnableOption "Upwind Security Components";

    enableScanner = mkOption {
      type = types.bool;
      default = true;
      description = "Enable the Upwind Sensor Scanner.";
    };

    enableHostconfig = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Upwind Sensor Hostconfig.";
    };

    sensorVersion = mkOption {
      type = types.str;
      default = "stable";
      description = "The Upwind Sensor version.";
    };

    hostconfigVersion = mkOption {
      type = types.str;
      default = "stable";
      description = "The Upwind Sensor Hostconfig version.";
    };

    region = mkOption {
      type = types.enum [ "us" "eu" ];
      default = "us";
      description = "Upwind region.";
    };

    logLevel = mkOption {
      type = types.str;
      default = "error";
      description = "Log level for the sensor.";
    };

    # CPU and memory resource limits
    sensorCpuQuota = mkOption {
      type = types.int;
      default = 50;
      description = "Systemd CPUQuota setting for the sensor service (default 50%).";
    };

    sensorMemoryMax = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Maximum memory limit for the sensor service (e.g., '1G').";
    };

    sensorMemoryHigh = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Memory threshold for the sensor service when throttling begins.";
    };

    sensorEnvironment = mkOption {
      type =
        with lib.types;
        attrsOf (
          nullOr (oneOf [
            int
            str
            path
          ])
        );
      default = {};
      description = "Environment variables to set in the upwind-sensor service.";
    };

    # Scanner resource settings
    scannerCpuQuota = mkOption {
      type = types.int;
      default = 50;
      description = "CPU quota for the scanner service (default 50%).";
    };

    scannerCpuWeight = mkOption {
      type = types.nullOr types.int;
      default = 25;
      description = "CPU weight for the scanner service (default 25).";
    };

    scannerIoWeight = mkOption {
      type = types.nullOr types.int;
      default = 25;
      description = "I/O weight for the scanner service (default 25).";
    };

    scannerMemoryMax = mkOption {
      type = types.str;
      default = "1G";
      description = "Maximum memory limit for the scanner service (default '1G').";
    };

    scannerMemoryHigh = mkOption {
      type = types.str;
      default = "900M";
      description = "High memory limit for the scanner service (default '900M').";
    };

    scannerEnvironment = mkOption {
      type =
        with lib.types;
        attrsOf (
          nullOr (oneOf [
            int
            str
            path
          ])
        );
      default = {};
      description = "Environment variables to set in the upwind-sensor-scanner service.";
    };

    cloudProvider = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Explictly set cloud provider; default is auto-detect.";
    };

    cloudAccountId = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Explicitly set cloud account id; default is auto-detect.";
    };

    zone = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Explicitly set cloud zone/region; default is auto-detect.";
    };

    environmentFile = mkOption {
      type = types.listOf types.path;
      default = [];
      description = "List of environment files to load for Upwind services.";
    };

    extraConfig = mkOption {
      type =
        with lib.types;
        attrsOf (
          nullOr (oneOf [
            bool
            int
            str
            path
          ])
        );
      default = {};
      description = "Additional configuration added to /etc/upwind/agent.yaml";
    };

    # Development overrides
    dev.enable = lib.mkEnableOption "Enable dev settings";

    dev.sensorTarballUrl = mkOption {
      type = types.str;
      description = "Override sensor tarball url.";
      default = "";
    };

    dev.sensorTarballHash = mkOption {
      type = types.str;
      description = "Override sensor tarball hash.";
      default = "";
    };

    dev.hostconfigTarballUrl = mkOption {
      type = types.str;
      description = "Override hostconfig tarball url.";
      default = "";
    };

    dev.hostconfigTarballHash = mkOption {
      type = types.str;
      description = "Override hostconfig tarball hash.";
      default = "";
    };

    dev.authEndpoint = mkOption {
      type = types.str;
      description = "Override authentication endpoint.";
      default = "";
    };

    dev.apiEndpoint = mkOption {
      type = types.str;
      description = "Override api endpoint.";
      default = "";
    };

    # TODO: ... add options corresponding to UPWIND_ variables
    # TODO: Configure scanner exclusions
  };

  config = mkIf cfg.enable {
    # TODO: ... add features like sock-perf, proc-username
    environment.etc."upwind/agent.yaml".text = ''
      # Upwind Sensor Configuration generated by NixOS
      region: "${cfg.region}"
      api-host: "${apiEndpoint}"
      auth-endpoint: "${authEndpoint}"
      log-level: "${cfg.logLevel}"
      install-type: "std"
      platform: "host"
    ''
    + (if cfg.cloudProvider != null then "cloud-provider: \"${cfg.cloudProvider}\"\n" else "")
    + (if cfg.cloudAccountId != null then "cloud-account-id: \"${cfg.cloudAccountId}\"\n" else "")
    + (if cfg.zone != null then "zone: \"${cfg.zone}\"\n" else "")
    + extraConfigString;

    # TODO: ... other hostconfig specific settings
    environment.etc."upwind/agent-hostconfig.yaml".text = ''
      # Upwind Hostconfig Configuration generated by NixOS
      region: "${cfg.region}"
      api-host: "${apiEndpoint}"
      auth-endpoint: "${authEndpoint}"
      log-level: "${cfg.logLevel}"
    '';

    # Directory for oauth token
    systemd.tmpfiles.settings = {
      "10-upwind-sensor" = {
        "/var/run/secrets/upwind.io/agent" = {
          d = {
            group = "root";
            mode = "0700";
            user = "root";
          };
        };
      };
    };

    # Systemd Service Definition
    systemd.services.upwind-sensor = {
      description = "Upwind Sensor";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.sensorEnvironment;

      restartTriggers = [
        config.environment.etc."upwind/agent.yaml".source
      ];

      serviceConfig = {
        ExecStart = "${upwindPkg}/bin/upwind-sensor agent";
        Restart = "always";
        # Resource Controls - map options to systemd properties
        CPUQuota = "${builtins.toString cfg.sensorCpuQuota}%";
        MemoryMax = cfg.sensorMemoryMax; # Define memoryMax option
        MemoryHigh = cfg.sensorMemoryHigh; # Define memoryHigh option
        # ... other service settings
        EnvironmentFile = cfg.environmentFile;
      };
    };

    # Hostconfig Service
    systemd.services.upwind-sensor-hostconfig = mkIf cfg.enableHostconfig {
      description = "Upwind Sensor Hostconfig";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      restartTriggers = [
        config.environment.etc."upwind/agent.yaml".source
        config.environment.etc."upwind/agent-hostconfig.yaml".source 
      ];

      serviceConfig = {
        ExecStart = "${upwindPkg}/bin/upwind-sensor-hostconfig";
        Restart = "always";
        EnvironmentFile = cfg.environmentFile;
      };
    };

    # Scanner Service
    systemd.services.upwind-sensor-scanner = mkIf cfg.enableScanner {
      description = "Upwind Sensor Scanner";
      environment = cfg.scannerEnvironment;
      serviceConfig = {
        Type = "exec";
        ExecStart = "${upwindPkg}/bin/upwind-sensor scan --path=/";
        # Resource controls for scanner
        CPUQuota = "${builtins.toString cfg.scannerCpuQuota}%";
        CPUWeight = "${builtins.toString cfg.scannerCpuWeight}";
        IOWeight = "${builtins.toString cfg.scannerIoWeight}";
        MemoryMax = cfg.scannerMemoryMax;
        MemoryHigh = cfg.scannerMemoryHigh;
        # ...
        EnvironmentFile = cfg.environmentFile;
      };
    };

    # Scanner Timer
    systemd.timers.upwind-sensor-scanner = mkIf cfg.enableScanner {
       description = "Upwind Sensor Scanner Timer";
       wantedBy = [ "timers.target" ];
       timerConfig = {
         OnCalendar = "*:00:00"; # From script
         AccuracySec = "5m";   # From script
         Unit = "upwind-sensor-scanner.service";
       };
    };
  };
}
