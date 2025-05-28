# Upwind Sensor

## TODO

* Support Nix Flakes.

## Usage

Provide credentials to fetch artifacts:

```
UPWIND_AUTH_CLIENT_ID=...
UPWIND_AUTH_CLIENT_SECRET=...
```

In `configuration.nix`, enable the Upwind Sensor services with:

```
let
  upwindRepo = builtins.fetchTarball {
    url = "https://github.com/upwindsecurity/nix/archive/main.tar.gz";
  };
in {
  imports = [
    "${upwindRepo}/upwind-sensor"
  ];

  services.upwindSensor = {
    enable = true;
    enableScanner = true;
    sensorVersion = "0.111.2";   # (Optional) pin sensor/scanner version
    region = "us";               # Change to "eu" if needed
    logLevel = "info";
    environmentFile = [
      /path/to/credentials.env   # Contains the credential env vars
    ]
  };
}
```

Provide `upwind-sensor`, `upwind-sensor-scanner`, and `upwind-sensor-hostconfig`
services with the same credentials used at build time.

Credentials may be placed in an environment file out-of-band from nix, and the
path to that file set in the `environmentFile` attribute.

Depending on your deployment architecture, your nix-daemon may also need these
credentials to fetch the upwind-sensor tarball. If this is the case, the same
file can be passed to `systemd.services.nix-daemon.serviceConfig.EnvironmentFile`.

## Testing

The configuration in the `test/` directory can be used with nix-build
to test the build:

`nix-build test`
