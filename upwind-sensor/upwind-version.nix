# TODO: Github action to maintain the release metadata.
{
  # The latest stable release
  stable = {
    sensor = "0.111.2";  # 0.108.0 is current stable, this is just latest for testing
    hostconfig = "0.5.2";
  };
  
  # The latest dev release
  dev = {
    sensor = "0.111.2";
    hostconfig = "0.5.2";
  };

  # Hashes of the release artifacts
  hashes = {
    sensor = {
      "0.111.2" = {
        amd64 = "14c8ed136e918ca70e09abe784ee102f0e1b00e41f33a3b1bb7f981d9a32af58";
        arm64 = "4d9f2e12c57ed9374c532790f2e200b0d5d11cfa7627ace7f336ebacbebd3cb4";
      };
    };
    hostconfig = {
      "0.5.2" = {
        amd64 = "85cc27fc54d4ce2f24c12aca3d3673c2070381e9960502d4266520a5c3f37813";
        arm64 = "cfa90939c126c4b2449befd905bde31751b559d19ff1a2e8276d9f22ba954ac2";
      };
    };
  };
}