{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    vim
    helix

    git
    lazygit

    eza
    yazi

    rustup

    go
    gopls
    delve
    gotools
    golangci-lint
    golangci-lint-langserver

    wget

    nil
    nixfmt

    zsh

    rmpc
    mpd
  ];
}
