{ pkgs, ... }: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "z"
        "zsh-autosuggestions"
        "zsh-syntax-highlighting"
      ];
      theme = "robbyrussel";
    };
  };
}
