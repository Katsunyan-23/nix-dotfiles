{ pkgs, lib, ... }:

let
  tokyonight = import ./themes/tokyonight.nix;

  kittySettings = {
    font_family = "JetBrains Mono";
    bold_font = "auto";
    italic_font = "auto";
    font_size = "10.0";

    background_opacity = "0.95";
    window_padding_width = "8";
    placement_strategy = "center";

    enable_audio_bell = "no";
    confirm_os_window_close = "0";
    scrollback_lines = "10000";

    cursor_shape = "block";
    cursor_blink_interval = "0";

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
  environment.systemPackages = [ pkgs.kitty ];

  homix.".config/kitty/kitty.conf".source = kittyConfig;
}
