let
  pkgs = import <nixpkgs> { };
  config = pkgs.nixos [ ./configuration.nix ];
in
config.config.system.build.toplevel
