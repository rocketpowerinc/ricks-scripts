{
  description = "My First NixOS Flake";

  inputs = {
    # This tells Nix to use the 'unstable' branch (where the newest apps are)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # This pulls in the Flatpak manager you wanted in your config
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = { self, nixpkgs, nix-flatpak, ... }@inputs: {
    # Replace 'nixos' with your actual networking.hostName from your config
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        nix-flatpak.nixosModules.nix-flatpak
      ];
    };
  };
}