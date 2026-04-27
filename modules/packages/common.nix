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

    yt-dlp

    (writeShellScriptBin "music-dl" ''
      exec ${yt-dlp}/bin/yt-dlp -x \
        --embed-thumbnail --convert-thumbnails jpg --add-metadata \
        --parse-metadata "%(uploader)s:%(artist)s" \
        -o "%(uploader)s - %(title)s.%(ext)s" \
        -P ~/Music \
        "$@"
    '')
  ];
}
