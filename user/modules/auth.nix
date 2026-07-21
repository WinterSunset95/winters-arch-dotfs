{ pkgs, config, ... }: {
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry = {
      package = pkgs.pinentry-qt;
    };
  };

  home.packages  = with pkgs; [
    (pass.withExtensions (exts: [ exts.pass-otp ]))
    pass-secret-service
    polkit_gnome
  ];

  # Launch polkit agent declaratively instead of hardcoding /usr/lib paths
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Install = {
      Description = "polkit-gnome-authentication-agent-1";
      WantedBy = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
