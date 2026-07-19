{ pkgs, ... }: {
  # 1. Fonts
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
  ];

  # 2. GTK Theming
  gtk = {
    enable = true;
    theme = {
      name = "catppuccin-mocha-mauve-standard+rimless";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        tweaks = [ "rimless" ];
        variant = "mocha";
      };
    };
    
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      };
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
  };

  # 3. The Wayland Cursor Trap
  home.pointerCursor = {
    name = "catppuccin-mocha-mauve-cursors";
    package = pkgs.catppuccin-cursors.mochaMauve;
    size = 24;
    gtk.enable = true;
    x11.enable = true; # Required for XWayland fallback apps
  };
}
