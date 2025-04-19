{
  services.calibre-server = {
    enable = true;
    user = "eino";
    port = 8080;
  };
  networking.firewall.allowedTCPPorts = [ 8080 ];
}
