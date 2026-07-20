{ pkgs, config, ... }: {

  networking.hostName = "trix"; # Define your hostname.
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Tailscale
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "yes";
    };
  };

}
