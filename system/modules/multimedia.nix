{ pkgs, config, ... }: {
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];

  boot.extraModprobeConfig = ''
    # exclusive_caps=1 required for discord to see the camera
    # video_nr=9 /dev/video9 so it doesn't conflict with a real webcam
    options v4l2loopback exclusive_caps=1 video_nr=9 card_label="OBS Virtual Camera"
  '';
}
