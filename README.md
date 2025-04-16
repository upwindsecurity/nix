# Upwind Sensor

## TODO

* Change fetch so credentials don't end up in nix store
* Remove credentials from sensor.yaml, to systemd creds?, for same reason.
* Use latest version of scanner systemd service file
* Rename all the things from sensor to sensor since this is greenfield.
* Toggles for the hostconfig and scanner services.
* Support Nix Flakes.

## Usage

Add `./upwind/upwind-sensor.nix` to imports.

And enable the service with:

```
services.upwindSensor = {
  enable = true;
  region = "us";                                        # Change to "eu" if needed
  clientId = "BlobOfRandomCharacters";                  # Change to actual clientId
  clientSecretFile = "/path/to/upwind-client-secret";   # Update with actual path
  logLevel = "info";
};
```
