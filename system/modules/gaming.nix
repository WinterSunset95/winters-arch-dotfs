{ pkgs, config, ... }: {

  hardware.graphics.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope = {
    enable = true;
    enableWsi = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };
}
