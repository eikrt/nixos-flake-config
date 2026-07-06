{ inputs, outputs, lib, config, pkgs, ... }: {
  imports = [ ];
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
    ];
    config = { allowUnfree = true; };
  };

  nix = let flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
systemd.targets.sleep.enable = false;
systemd.targets.suspend.enable = false;
systemd.targets.hibernate.enable = false;
systemd.targets.hybrid-sleep.enable = false;
  users.extraUsers.eino.extraGroups = [ "jackaudio" "audio" ];
  environment.systemPackages = (import ../pkgs/code.nix) { inherit pkgs; }
    ++ (import ../pkgs/utils.nix) { inherit pkgs; }
    ++ (import ../pkgs/game.nix) { inherit pkgs; }
    ++ (import ../pkgs/audio.nix) { inherit pkgs; }
    ++ (import ../pkgs/studio.nix) { inherit pkgs; }
    ++ (import ../pkgs/nix.nix) { inherit pkgs; };
  networking.firewall.allowedTCPPorts = [ 3389 ];
  networking.firewall.allowedUDPPorts = [ 3389 ];
  system.stateVersion = "23.05";
}

