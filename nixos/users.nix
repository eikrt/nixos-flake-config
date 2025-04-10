{
  users.users = {
    eino = {
      initialPassword = "camel1234";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      extraGroups = [ "networkmanager" "wheel" "docker" ];
    };
  };
}
