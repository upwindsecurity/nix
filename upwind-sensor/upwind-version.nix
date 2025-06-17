# TODO: Github action to maintain the release metadata.
{
  # The latest stable release
  stable = {
    sensor = "0.115.3";
    hostconfig = "0.5.2";
  };
  
  # The latest dev release
  dev = {
    sensor = "0.115.3";
    hostconfig = "0.5.2";
  };

  # Hashes of the release artifacts
  hashes = {
    sensor = {
      "0.111.2" = {
        amd64 = "14c8ed136e918ca70e09abe784ee102f0e1b00e41f33a3b1bb7f981d9a32af58";
        arm64 = "4d9f2e12c57ed9374c532790f2e200b0d5d11cfa7627ace7f336ebacbebd3cb4";
      };
      "0.115.3" = {
        amd64 = "690bb87285595c010cca7f0bff7defaef95b899000c03bf553b1bd9cbd53dd25";
        arm64 = "f6dc098e168e402f0061567f8367ffcee9e12bfdbdfb9fe4068f08093c9c2025";
      };
      "0.116.0-alpha1" = {
        amd64 = "2d037872bd09ac4b38ea6823bbf875277e00ea4eed8a9098b854b476637ce20c";
        arm64 = "bd9814046197bb9b462e8cc3aa25515262a72fa6f41320b0a85d6577bb685089";
      };
      "0.116.0-alpha2" = {
        amd64 = "77c184f213cd90d93cfd30dbb331b33f767c17251dd434a1ea1d31ebfa3e6881";
        arm64 = "f57aea4525c1f988b5d66b95d0642aece6cf8d3ee1e4e89d714c87a41ab88d6a";
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