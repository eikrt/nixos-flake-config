{

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.loader.grub.enableCryptodisk = true;
}
