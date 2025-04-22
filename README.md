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

Add `./upwind/upwind-sensor.nix` to imports.

Enable the service(s) with:

```
services.upwindSensor = {
  enable = true;
  enableScanner = true;
  enableHostconfig = true;
  sensorVersion = "0.111.2";   # (Optional) pin sensor/scanner version
  hostconfigVersion = "0.5.2"; # (Optional) pin hostconfig version
  region = "us";               # Change to "eu" if needed
  logLevel = "info";
};
```

Provide `upwind-sensor` and `upwind-sensor-hostconfig` services with
the same credentials used at build time.
