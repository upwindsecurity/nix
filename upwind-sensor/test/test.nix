{ pkgs ? import <nixpkgs> {} }:
let
  defaultSystem = "x86_64-linux";
  defaultSensorVersion = "0.119.0";
  defaultHostconfigVersion = "0.7.0";
  defaultRegion = "us";

  # evaluate release with defaults overriden by 'attrs'
  mkRelease = attrs: import ../release.nix ( {
    lib = pkgs.lib;
    system = defaultSystem;
    sensorVersion = defaultSensorVersion;
    hostconfigVersion = defaultHostconfigVersion;
    region = defaultRegion;
    dev = null;
  } // attrs );

  dev = {
    sensorTarballUrl = "https://example.com/sensor.tar.gz";
    sensorTarballHash = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    hostconfigTarballUrl = "https://example.com/hostconfig.tar.gz";
    hostconfigTarballHash = "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb";
    authEndpoint = "https://auth.example.com";
    authAudience = "https://aud.example.com";
  };
in
  pkgs.lib.debug.runTests {
    ### Domains

    # default region domain is "upwind.io"
    testRegionDefault = {
      expr = (mkRelease { }).regionDomain;
      expected = "upwind.io";
    };

    # if region is set to "us", the domain should still be "upwind.io"
    testRegionUS = {
      expr = (mkRelease { region = "us"; }).regionDomain;
      expected = "upwind.io";
    };

    # "eu" and other regions make domains like "eu.upwind.io"
    testRegionEU = {
      expr = (mkRelease { region = "eu"; }).regionDomain;
      expected = "eu.upwind.io";
    };

    # default releases domain is "releases.upwind.io"
    testReleasesDefault = {
      expr = (mkRelease { }).releasesDomain;
      expected = "releases.upwind.io";
    };

    # and for "eu" it is "releases.eu.upwind.io"
    testReleasesEU = {
      expr = (mkRelease { region = "eu"; }).releasesDomain;
      expected = "releases.eu.upwind.io";
    };

    ### Sensor

    testReleasePackages = {
      expr = (mkRelease { }).packages;
      expected = {
        authAudience = "https://agent.upwind.io";
        authEndpoint = "https://oauth.upwind.io/oauth/token";

        sensorTarballUrl = "https://releases.upwind.io/upwind-agent/v0.119.0/upwind-agent-v0.119.0-linux-amd64.tar.gz";
        sensorTarballHash = "4cfa32684135322a9ff748b6143f4ef4dcd7e9509630d93a7f415aec32fe1776";
        sensorTarballName = "upwind-agent-v0.119.0-linux-amd64.tar.gz";

        hostconfigTarballUrl = "https://releases.upwind.io/upwind-agent-hostconfig/v0.7.0/upwind-agent-hostconfig-v0.7.0-linux-amd64.tar.gz";
        hostconfigTarballHash = "b0d9e1693dd2c0991e9d5ac928a158a7b51931ae1edafc6f4d043eb1473b31bf";
        hostconfigTarballName = "upwind-agent-hostconfig-v0.7.0-linux-amd64.tar.gz";
      };
    };

    ### Dev

    # if dev is set, those are passed through to the packages
    # attribute, and the names are derived from the urls
    testDev = {
      expr = (mkRelease { inherit dev; }).packages;
      expected = {
        sensorTarballUrl = dev.sensorTarballUrl;
        sensorTarballHash = dev.sensorTarballHash;
        sensorTarballName = "sensor.tar.gz";
        hostconfigTarballUrl = dev.hostconfigTarballUrl;
        hostconfigTarballHash = dev.hostconfigTarballHash;
        hostconfigTarballName = "hostconfig.tar.gz";
        authEndpoint = dev.authEndpoint;
        authAudience = dev.authAudience;
      };
    };
  }
