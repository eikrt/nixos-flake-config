{ config, pkgs, ... }: {
  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
  services.prometheus.exporters.node = {
    enable = true;
    port = 9001;
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
    enabledCollectors = [ "systemd" ];
    # /nix/store/zgsw0yx18v10xa58psanfabmg95nl2bb-node_exporter-1.8.1/bin/node_exporter  --help
    extraFlags = [
      "--collector.ethtool"
      "--collector.softirqs"
      "--collector.tcpstat"
      "--collector.wifi"
    ];
  };
  services.prometheus = {
    enable = true;
    scrapeConfigs = [{
      job_name = "node";
      static_configs = [{ targets = [ "localhost:9001" ]; }];
    }];
  };
  networking.firewall.allowedTCPPorts = [ 9001 9090 ];
}
