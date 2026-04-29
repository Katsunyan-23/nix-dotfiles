{ pkgs, ... }:

{
  # Profile-specific packages (shared packages are in modules/packages/common.nix)
  environment.systemPackages = with pkgs; [
    ffmpeg
    sox
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    jetbrains-mono
  ];

  nix-homebrew = {
    enable = true;
    enableRosetta = false;
    user = "katsunyan";
  };

  homebrew = {
    enable = true;
    casks = [
      "firefox"
      "hammerspoon"
    ];
    onActivation.autoUpdate = false;
  };

  system.primaryUser = "katsunyan";

  nixpkgs.config.allowUnfree = true;

  nix.enable = false;

  system.stateVersion = 5;
}
