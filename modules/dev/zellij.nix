{ pkgs, ... }:

let
  zellijConfig = pkgs.writeText "config.kdl" ''
    passthrough_escape_codes true

    theme "tokyo-night"

    themes {
        tokyo-night {
            fg 169 177 214
            bg 26 27 38
            black 21 22 30
            red 247 118 142
            green 158 206 106
            yellow 224 175 104
            blue 122 162 247
            magenta 187 154 247
            cyan 125 207 255
            white 192 202 245
            orange 255 158 100
        }
    }
  '';
in
{
  environment.systemPackages = [ pkgs.zellij ];
  homix.".config/zellij/config.kdl".source = zellijConfig;

  programs.zsh.interactiveShellInit = ''
    if [[ -z "$ZELLIJ" ]]; then
      ${pkgs.zellij}/bin/zellij
    fi
  '';
}
