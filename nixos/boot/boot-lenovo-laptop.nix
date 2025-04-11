{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };
  boot.loader.grub.enableCryptodisk = true;
}
