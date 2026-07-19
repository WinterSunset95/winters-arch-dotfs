{ config, pkgs, ... }: {
	home.username = "autumn";
	home.homeDirectory = "/home/autumn";

	programs.home-manager.enable = true;
	programs.dank-material-shell.enable = true;
	programs.kitty.enable = true;
	programs.tmux.enable = true;
	programs.neovim.enable = true;

	xdg.configFile."niri".source = ./niri;
	xdg.configFile."tmux".source = ./tmux;
	xdg.configFile."nvim".source = ./nvim;
	home.stateVersion = "24.05";
}

