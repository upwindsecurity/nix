# TODO: Github action to maintain the release metadata.
{
  # The latest stable release
  stable = {
    sensor = "0.111.0";
    hostconfig = "0.5.2";
  };
  
  # The latest dev release
  dev = {
    sensor = "0.111.0";
    hostconfig = "0.5.2";
  };

  # Hashes of the release artifacts
  hashes = {
    sensor = {
      "0.111.0" = {
        amd64 = "";
        arm64 = "";
      };
    };
    hostconfig {
      "0.5.2" = {
        amd64 = "";
        arm64 = "";
      };
    };
  }
}