{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    homix.url = "github:sioodmy/homix";
  };

  outputs =
    {
      self,
      nixpkgs,
      homix,
      ...
    }:
    {
      nixosConfigurations.home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./modules/dev/helix.nix
          ./modules/dev/kitty.nix
          homix.nixosModules.default
        ];
      };
    };
}
