{ pkgs, config, ... }: {
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    port = 2283;
    mediaLocation = "/var/lib/immich";
    accelerationDevices = null;
  };

  users.users.immich.extraGroups = [ "video" "render" ];
}
