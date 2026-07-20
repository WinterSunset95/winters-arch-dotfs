{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    
    # Pulls the official Catppuccin Mocha theme from the kitty-themes repository
    themeFile = "Catppuccin-Mocha";

    # Since we already installed the Nerd Font in theme.nix, we just declare the name here
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 13;
    };

    # Automatically hooks into the Zsh module we created earlier
    shellIntegration = {
      enableZshIntegration = true;
    };

    settings = {
      window_padding_width = 4;
      background_opacity = "0.95";
      enable_audio_bell = false;
      # Disables the annoying "Are you sure you want to close this terminal?" popup
      confirm_os_window_close = 0; 
      
      # Wayland-specific performance tweaks
      linux_display_server = "wayland";
      wayland_titlebar_color = "background";
      sync_to_monitor = true;
    };

    keybindings = {
      # Font size manipulation
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+0" = "change_font_size all 0";
    };
  };
}
