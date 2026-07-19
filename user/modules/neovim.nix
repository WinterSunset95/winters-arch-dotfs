{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      nodejs
        gnumake
        gcc
        ripgrep
        fd
        cargo
        xclip
    ];
  };

  xdg.configFile."nvim".source = ../nvim;
 }
