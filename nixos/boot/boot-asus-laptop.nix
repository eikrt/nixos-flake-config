{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  #boot.loader.grub.enableCryptodisk = true;
}
