{ pkgs, config, ... }: 
let
  sddm-astronaut = (pkgs.sddm-astronaut.override {
    embeddedTheme = "black_hole";  # or any other theme
  });
in
{
  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    extraPackages = with pkgs; [
      kdePackages.qtmultimedia # Required for video backgrounds/audio
      kdePackages.qtsvg
      sddm-astronaut
    ];
    theme = "sddm-astronaut-theme";
  };
}
