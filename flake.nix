{
  description = "NIX CONFIG EINO KORTE";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    # Your custom packages
    # Accessible through 'nix build', 'nix shell', etc
    # packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    # Formatter for your nix files, available through 'nix fmt'
    # Other options beside 'alejandra' include 'nixpkgs-fmt'
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};
    # Reusable nixos modules you might want to export
    # These are usually stuff you would upstream into nixpkgs
    nixosModules = import ./modules/nixos;
    # Reusable home-manager modules you might want to export
    # These are usually stuff you would upstream into home-manager
    homeManagerModules = import ./modules/home-manager;

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # FIXME replace with your hostname
      nixos-home-pc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hardware-configurations/hardware-configuration-home-pc.nix
          ./nixos/audio.nix
          ./nixos/backup.nix
          ./nixos/boot/boot-home-pc.nix
          ./nixos/display.nix
          ./nixos/docker.nix
          ./nixos/gpu.nix
          ./nixos/grafana.nix
          ./nixos/hardware.nix
          ./nixos/jellyfin.nix
          ./nixos/locale.nix
          ./nixos/networking.nix
          ./nixos/sleep-disable.nix
          ./nixos/steam.nix
          ./nixos/syncthing.nix
          ./nixos/systemd.nix
          ./nixos/users.nix
          ./nixos/virtualization.nix
          ./nixos/tailscale.nix
          ./nixos/configurations/configuration-home.nix
        ];
      };
      nixos-qemu-arm = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hardware-configurations/hardware-configuration-qemu-arm.nix
          ./nixos/audio.nix
          ./nixos/boot/boot-virtual-work.nix
          ./nixos/hardware.nix
          ./nixos/display.nix
          ./nixos/docker.nix
          ./nixos/locale.nix
          ./nixos/networking.nix
          ./nixos/syncthing.nix
          ./nixos/systemd.nix
          ./nixos/users.nix
          ./nixos/wireguard-client.nix
          ./nixos/configurations/configuration-work.nix
        ];
      };
      nixos-lenovo-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hardware-configurations/hardware-configuration-lenovo-laptop.nix
          ./nixos/audio.nix
          ./nixos/boot/boot-lenovo-laptop.nix
          ./nixos/display.nix
          ./nixos/hardware.nix
          ./nixos/docker.nix
          ./nixos/locale.nix
          ./nixos/networking.nix
          ./nixos/steam.nix
          ./nixos/syncthing.nix
          ./nixos/systemd.nix
          ./nixos/users.nix
          ./nixos/configurations/configuration-lenovo-laptop.nix
        ];
      };
      nixos-asus-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./nixos/hardware-configurations/hardware-configuration-asus-laptop.nix
          ./nixos/audio.nix
          ./nixos/boot/boot-asus-laptop.nix
          ./nixos/display.nix
          ./nixos/hardware.nix
          ./nixos/locale.nix
          ./nixos/networking.nix
          ./nixos/systemd.nix
          ./nixos/users.nix
          ./nixos/tailscale.nix
          ./nixos/configurations/configuration-lenovo-laptop.nix
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "eino@nixos-home-pc" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
        ];
      };
      "eino@nixos-asus-laptop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home.nix
        ];
      };
      "eino@nixos-qemu-arm" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/home-work.nix
        ];
      };
    };
  };
}
