{ config, pkgs, inputs, ... }: {
  imports = [
    ./modules/browsers.nix
    ./modules/neovim.nix
    ./modules/tmux.nix
    ./modules/discord.nix
    ./modules/shell_tools.nix
    ./modules/zsh.nix
    ./modules/theme.nix
    ./modules/kitty.nix
    ./modules/media.nix
    ./modules/email.nix
    ./modules/qol.nix
    ./modules/minecraft.nix
  ];

  nixpkgs.config.allowUnfree = true;

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

    spotify
    spotify-player
  ];


	programs.home-manager.enable = true;
	programs.kitty.enable = true;
	programs.dank-material-shell.enable = true;
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "red"; # Options: rosewater, flamingo, pink, mauve, red, maroon, peach, yellow, green, teal, sky, sapphire, blue, lavender
    cursors.enable = true;
  };

  xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/winters-arch-dotfs/niri";

	home.stateVersion = "26.05";
}

