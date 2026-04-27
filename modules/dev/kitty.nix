{ pkgs, lib, ... }:

let
  tokyonight = import ./themes/tokyonight.nix;

  kittySettings = {
    font_family = "JetBrains Mono";
    bold_font = "auto";
    italic_font = "auto";
    font_size = "15.0";

    remember_window_size = "no";
    macos_traditional_fullscreen = "yes";
    startup_session = "~/.config/kitty/startup.session";

    background_opacity = "0.95";
    window_padding_width = "8";
    placement_strategy = "center";

    macos_option_as_alt = "no";

    enable_audio_bell = "no";
    confirm_os_window_close = "0";
    scrollback_lines = "10000";

    cursor_shape = "block";
    cursor_blink_interval = "0";

    tab_bar_style = "powerline";
    tab_powerline_style = "slanted";

    show_startup_tips = "false";

    shell = "${pkgs.zsh}/bin/zsh";

    extraConfig = ''
      map ctrl+shift+/ show_scrollback
      map cmd+f send_key alt+f
    '';

  }
  // tokyonight;

  kittyConfig = pkgs.writeText "kitty.conf" (
    lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k} ${v}") kittySettings)
  );

  startupSession = pkgs.writeText "startup.session" ''
    os_window_state fullscreen
    launch
  '';
in
{
  environment.systemPackages = [ pkgs.kitty ];

  homix.".config/kitty/kitty.conf".source = kittyConfig;
  homix.".config/kitty/startup.session".source = startupSession;
}
