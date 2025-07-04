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
        amd64 = "c9a037b66455fc9ab9ddfc719628154ab7f9495bb4efafb4ab0a8eb159539a53";
        arm64 = "bed4f044859747755af52cd9b93f8a8b3f0ce3d1c477498add604b1a1e8ac2d0";
      };
      "0.116.0-alpha1" = {
        amd64 = "2d037872bd09ac4b38ea6823bbf875277e00ea4eed8a9098b854b476637ce20c";
        arm64 = "bd9814046197bb9b462e8cc3aa25515262a72fa6f41320b0a85d6577bb685089";
      };
      "0.116.0-alpha2" = {
        amd64 = "77c184f213cd90d93cfd30dbb331b33f767c17251dd434a1ea1d31ebfa3e6881";
        arm64 = "f57aea4525c1f988b5d66b95d0642aece6cf8d3ee1e4e89d714c87a41ab88d6a";
      };
      "0.116.2-alpha1" = {
        amd64 = "1596434f5c19897db38334caa7b466bf7da5b2936f9737147ad7646f535cc628";
        arm64 = "085aba5ed1fb5baa27d1249b6d2c8cc609a7a4c3c9f3ad208651616261cc2efd";
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