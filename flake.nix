{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ghostty,
      hypridle,
      hyprlock,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        download-buffer-size = "512MiB";
        modules = [
          ./hosts/default/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
}
