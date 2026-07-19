{ config, pkgs, inputs, ... }: {
  imports = [
    ./modules/qutebrowser.nix
    ./modules/neovim.nix
    inputs.dms.homeModules.dank-material-shell
  ];
	home.username = "autumn";
	home.homeDirectory = "/home/autumn";

	programs.home-manager.enable = true;
	programs.dank-material-shell.enable = true;
	programs.kitty.enable = true;
	programs.tmux.enable = true;
  programs.firefox.enable = true;

	xdg.configFile."niri".source = ./niri;
	xdg.configFile."tmux".source = ./tmux;

	home.stateVersion = "24.05";
}

