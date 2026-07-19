{ config, pkgs, inputs, ... }: {
  imports = [
    ./modules/qutebrowser.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/discord.nix
    ./modules/zoxide.nix
    ./modules/gh.nix
    ./modules/zsh.nix
    ./modules/theme.nix
    ./modules/kitty.nix
  ];

	home.username = "autumn";
	home.homeDirectory = "/home/autumn";
  home.packages  = with pkgs; [
    beeper
  ];


	programs.home-manager.enable = true;
	programs.kitty.enable = true;
  programs.firefox.enable = true;
	programs.dank-material-shell.enable = true;

  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink "{config.home.homeDirectory}/winters-arch-dotfs/niri";

	home.stateVersion = "26.05";
}

