{ pkgs, lib, ... }:

let
  tokyonight = import ./themes/tokyonight.nix;

  kittySettings = {
    # Font
    font_family = "JetBrains Mono";
    bold_font = "JetBrains Mono Bold";
    italic_font = "JetBrains Mono Italic";
    font_size = "10.0";

    # Window
    background_opacity = "0.95";
    window_padding_width = "8";
    placement_strategy = "center";

    # Behavior
    enable_audio_bell = "no";
    confirm_os_window_close = "0";
    scrollback_lines = "10000";

    # Cursor
    cursor_shape = "block";
    cursor_blink_interval = "0";

    # Tab bar
    tab_bar_style = "powerline";
    tab_powerline_style = "slanted";

    shell = "${pkgs.zsh}/bin/zsh";

  }
  // tokyonight;

  kittyConfig = pkgs.writeText "kitty.conf" (
    lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k} ${v}") kittySettings)
  );
in
{
  environment.systemPackages = [
    (pkgs.symlinkJoin {
      name = "kitty";
      paths = [ pkgs.kitty ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/kitty \
          --add-flags "--config=${kittyConfig}"
      '';
    })
  ];
}
