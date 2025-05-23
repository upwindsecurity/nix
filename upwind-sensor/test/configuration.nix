{ config, pkgs, ... }:
{
  imports = [
    ../default.nix
  ];
  services.upwindSensor = {
    enable = true;
    domain = "upwind.io";
    cloudProvider = "byoc";
    cloudAccountId = "byoc-1234";
    zone = "byoc-east";
  };

  # ---------------------------------------------------------------------------
  system.stateVersion = "25.05";
  boot.loader.systemd-boot.enable = true;
  users.users.testuser.isNormalUser = true;
  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/510da090-fb98-458e-86e1-bfd728741d02";
      fsType = "ext4";
    };
}