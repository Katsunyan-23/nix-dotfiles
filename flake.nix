{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    homix.url = "github:sioodmy/homix";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    {
      self,
      nixpkgs,
      homix,
      nix-darwin,
      nix-homebrew,
      ...
    }:
    {
      nixosConfigurations.home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./modules/packages/common.nix
          ./modules/dev/helix.nix
          ./modules/dev/kitty.nix
          ./modules/dev/zellij.nix
          ./modules/dev/rmpc.nix
          ./modules/dev/mpd.nix
          ./modules/dev/zsh.nix
          homix.nixosModules.default
        ];
      };

      darwinConfigurations.home-mac = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin-configuration.nix
          ./modules/packages/common.nix
          ./modules/darwin-homix.nix
          ./modules/dev/helix.nix
          ./modules/dev/kitty.nix
          ./modules/dev/yazi.nix
          ./modules/dev/zellij.nix
          ./modules/dev/hammerspoon.nix
          ./modules/dev/rmpc.nix
          ./modules/dev/mpd-darwin.nix
          ./modules/dev/zsh.nix
          nix-homebrew.darwinModules.nix-homebrew
        ];
      };
    };
}
