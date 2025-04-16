# Upwind Sensor

## TODO

* Change fetch so credentials don't end up in nix store
* Remove credentials from agent.yaml, to systemd creds?, for same reason.
* Use latest version of scanner systemd service file
* Rename all the things from agent to sensor since this is greenfield.
* Toggles for the hostconfig and scanner services.
* Support Nix Flakes.

## Usage

Add `./upwind/upwind-agent.nix` to imports.

And enable the service with:

```
services.upwindAgent = {
  enable = true;
  region = "us"; # Change to "eu" if needed
  clientIdFile = "/run/secrets/upwind-client-id"; # Update with actual path
  clientSecretFile = "/run/secrets/upwind-client-secret"; # Update with actual path
  logLevel = "info";
};
```
