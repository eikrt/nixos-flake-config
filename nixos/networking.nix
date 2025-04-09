{
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  networking.firewall.checkReversePath = "loose";
}
