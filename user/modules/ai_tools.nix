{ pkgs, config, ... }:
let
  aider-full = pkgs.aider-chat.overrideAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ (with pkgs.python3Packages; [
      google-generativeai
      playwright
    ]);
  });
in
{
  home.packages = [
    pkgs.antigravity-cli
    aider-full
  ];

  programs.antigravity-cli = {
    enable = true;
    enableMcpIntegration = true;
  };
}
