{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shortcut = "b"; # Corresponds to your C-b prefix
    mouse = true;
    keyMode = "vi";
    baseIndex = 1;
    escapeTime = 10;
    historyLimit = 100000;
    terminal = "screen-256color";

    # Nix handles the downloading, compiling, and sourcing of TPM plugins automatically
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      battery
      cpu
      vim-tmux-navigator
      catppuccin
    ];

    extraConfig = ''
      # Pane indexing and focus events
      set -g pane-base-index 1
      set-option -g focus-events on

      # Copy mode vi binds
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel

      # Window navigation (Custom)
      bind-key -n C-S-j next-window
      bind-key -n C-S-k previous-window
      bind-key l last-window

      # --- CATPPUCCIN THEME CONFIG ---
      set -g @catppuccin_flavour 'mocha'
      set -g status-justify centre
      set -g status-right-length 100
      set -g status-left-length 100
      
      set -gq @catppuccin_pane_status_enabled "yes"
      set -gq @catppuccin_pane_border_status "yes"
      
      set -gq @catppuccin_window_status_style "slanted"
      set -gq @catppuccin_window_text " #W"
      set -gq @catppuccin_window_number "#I"
      set -gq @catppuccin_window_current_number "#I"
      set -gq @catppuccin_window_number_position "left"
      set -gq @catppuccin_window_connect_separator "yes"

      set -gq @catppuccin_status_left_separator ""
      set -gq @catppuccin_status_middle_separator ""
      set -gq @catppuccin_status_right_separator " "
      set -gq @catppuccin_status_connect_separator "yes"
    '';
  };
}
