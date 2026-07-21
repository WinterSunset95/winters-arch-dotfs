{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 100000;
      save = 100000;
      ignoreDups = true;
      share = true;
    };

    shellAliases = {
      ll = "ls -la";
      update-sys = "sudo nixos-rebuild switch --flake .#trix";
      update-home = "home-manager switch --flake .#autumn";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "sudo"
      ];
      theme = "robbyrussell";
    };
  };
}
