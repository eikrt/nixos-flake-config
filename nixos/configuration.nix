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

  environment.systemPackages = (import ./packages/code.nix) { inherit pkgs; }
    ++ (import ./packages/game.nix) { inherit pkgs; }
    ++ (import ./packages/utils.nix) { inherit pkgs; };
  networking.firewall.allowedTCPPorts = [ ];
  system.stateVersion = "23.05";
}
