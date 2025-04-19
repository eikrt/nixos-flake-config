{ config, lib, pkgs, ... }:

let
  # Create the rsync shell script
  syncScript = pkgs.writeShellScript "sync-backup" ''
    set -euo pipefail
    rsync -av /mnt/HDD/Music/   /var/lib/syncthing/Music/
    rsync -av /mnt/HDD/Games/   /var/lib/syncthing/Games/
    rsync -av /mnt/HDD/Notes/   /var/lib/syncthing/Notes/
    rsync -av /mnt/HDD/Movies/  /var/lib/syncthing/Movies/
    rsync -av /mnt/HDD/Books/  /var/lib/syncthing/Books/
  '';
in
{
  services.cron = {
    enable = true;

    systemCronJobs = [
      "0 * * * *    root    ${syncScript}"
    ];
  };
}
