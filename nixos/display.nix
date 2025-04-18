{ pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # services.xrdp.enable = true;
  # services.xrdp.defaultWindowManager = "${pkgs.gnome-session}/bin/gnome-session";
  # services.xrdp.openFirewall = true;
  # services.gnome.gnome-remote-desktop.enable = true;
  services.xserver = {
    layout = "fi";
    xkbVariant = "";
  };
}
