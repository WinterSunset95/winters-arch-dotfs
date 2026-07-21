{ pkgs, ... }: {
  home.packages = with pkgs; [
    nemo-with-extensions
    nemo-fileroller
    # nemo-terminal

    proton-vpn
    proton-vpn-cli

    wireguard-tools

    thunar
    thunar-archive-plugin
    thunar-volman

    xwayland-satellite
  ];

  programs.zathura = {
    enable = true;
  };
}
