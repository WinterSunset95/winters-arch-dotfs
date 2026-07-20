{ pkgs, config, ... }: {
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  boot.kernel.sysctl."vm.swappiness" = 10;

  services.earlyoom = {
    enable = true;
    freeMemKillThreshold = 5;
    freeSwapThreshold = 10;
    extraArgs = [
      "--prefer '^qutebrowser$'"
      "--avoid '^niri$|^kitty$|^sshd$'"
    ];
  };
}
