{ pkgs, ... }: {
  programs.nixcord = {
    enable = true;
    
    # We use Vesktop instead of the official client for Wayland/Pipewire support
    discord.enable = false;
    vesktop.enable = true;

    config = {
      useQuickCss = true;
      themeLinks = [
        # Matches your Tmux theme
        "https://raw.githubusercontent.com/catppuccin/discord/main/themes/mocha.theme.css"
      ];
      
      plugins = {
        hideMedia.enable = true;
        messageLogger.enable = true; # Keeps deleted messages visible locally
        typingTweaks.enable = true;
        voiceChatDoubleClick.enable = true;
        webKeybinds.enable = true;
        alwaysTrust.enable = true;
        clearUrls.enable = true; # Strips tracking parameters from links
      };
    };
  };
}
