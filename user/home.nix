{ config, pkgs, inputs, ... }: {
  imports = [
    ./modules/qutebrowser.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/discord.nix
    ./modules/shell_tools.nix
    ./modules/zsh.nix
    ./modules/theme.nix
    ./modules/kitty.nix
    ./modules/media.nix
    ./modules/email.nix
  ];

  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry = { 
      package = pkgs.pinentry-curses;
    };
  };

	home.username = "autumn";
	home.homeDirectory = "/home/autumn";
  home.packages  = with pkgs; [
    beeper
    (pass.withExtensions (exts: [ exts.pass-otp ]))
    pass-secret-service
    keepassxc
  ];


	programs.home-manager.enable = true;
	programs.kitty.enable = true;
  programs.firefox.enable = true;
	programs.dank-material-shell.enable = true;

  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink "{config.home.homeDirectory}/winters-arch-dotfs/niri";

	home.stateVersion = "26.05";
}

