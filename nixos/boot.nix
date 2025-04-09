{

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  #boot.initrd.secrets = {
  #  "/crypto_keyfile.bin" = null;
  #};

 # boot.initrd.luks.devices = lib.optionalAttrs((config.boot.encryptedDisk) {
 #   "luks-2838b664-58a4-47df-b5a6-b7b00b19f03e".keyFile = "/crypto_keyfile.bin";
 # });

  # Import devices from hardware-luks-devices
  #boot.initrd.devices = config.hardware-luks-devices;
  boot.loader.grub.enableCryptodisk = encryptedDisk;
}
