# Upwind Sensor

## TODO

* Use latest version of scanner systemd service file
* Support Nix Flakes.

## Usage

Provide credentials to fetch artifacts:

```
UPWIND_CLIENT_ID=...
UPWIND_CLIENT_SECRET=...
```

Import `upwind-sensor`.

Enable the service(s) with:

```
services.upwind = {
  enable = true;
  enableScanner = true;
  enableHostconfig = true;
  sensorVersion = "0.111.2";   # (Optional) pin sensor/scanner version
  hostconfigVersion = "0.5.2"; # (Optional) pin hostconfig version
  region = "us";               # Change to "eu" if needed
  logLevel = "info";
};
```

Provide `upwind-sensor`, `upwind-sensor-scanner`, and `upwind-sensor-hostconfig`
services with the same credentials used at build time.

## Testing

The configuration in the `test/` directory can be used with nix-build
to test the build:

`nix-build test/test.nix`
