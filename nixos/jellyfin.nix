{ pkgs, ... }: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    user="eino";
  };
}
