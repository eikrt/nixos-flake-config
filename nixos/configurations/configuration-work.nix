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

  environment.systemPackages = (import ../pkgs/code.nix) { inherit pkgs; }
    ++ (import ../pkgs/utils.nix) { inherit pkgs; };
  networking.firewall.allowedTCPPorts = [ 22 2377 2376 7946 ];
  networking.firewall.allowedUDPPorts = [ 4789 7946 ];
  system.stateVersion = "23.05";
}
