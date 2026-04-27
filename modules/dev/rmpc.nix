{ pkgs, ... }:
let
  tokyonight = import ./themes/tokyonight.nix;

  theme = pkgs.writeText "tokyonight.ron" ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
        background_color: "${tokyonight.background}",
        text_color: "${tokyonight.foreground}",
        header_background_color: "${tokyonight.background}",
        modal_background_color: "${tokyonight.color0}",
        modal_backdrop: true,

        preview_label_style: (fg: "${tokyonight.color3}"),
        preview_metadata_group_style: (fg: "${tokyonight.color3}", modifiers: "Bold"),
        highlighted_item_style: (fg: "${tokyonight.color4}", modifiers: "Bold"),
        current_item_style: (fg: "${tokyonight.color0}", bg: "${tokyonight.color4}", modifiers: "Bold"),
        borders_style: (fg: "${tokyonight.color8}"),
        highlight_border_style: (fg: "${tokyonight.color4}"),

        symbols: (
            song: "󰎇 ",
            dir: " ",
            playlist: "󰲸 ",
            marker: " ",
            ellipsis: "...",
            song_style: None,
            dir_style: None,
            playlist_style: None,
            marker_style: None,
            song_highlighted_style: None,
            dir_highlighted_style: None,
            playlist_highlighted_style: None,
            marker_highlighted_style: None,
            song_current_style: None,
            dir_current_style: None,
            playlist_current_style: None,
            marker_current_style: None,
        ),

        level_styles: (
            info:  (fg: "${tokyonight.color4}"),
            warn:  (fg: "${tokyonight.color3}"),
            error: (fg: "${tokyonight.color1}"),
            debug: (fg: "${tokyonight.color2}"),
            trace: (fg: "${tokyonight.color5}"),
        ),

        progress_bar: (
            symbols: ["─", "─", "●", "─", "─"],
            track_style: (fg: "${tokyonight.color8}"),
            elapsed_style: (fg: "${tokyonight.color4}"),
            thumb_style: (fg: "${tokyonight.color4}"),
            use_track_when_empty: true,
        ),

        scrollbar: (
            symbols: ["│", "█", "▲", "▼"],
            track_style: (fg: "${tokyonight.color8}"),
            ends_style: (fg: "${tokyonight.color8}"),
            thumb_style: (fg: "${tokyonight.color4}"),
        ),

        tab_bar: (
            active_style: (fg: "${tokyonight.color0}", bg: "${tokyonight.color4}", modifiers: "Bold"),
            inactive_style: (fg: "${tokyonight.color7}"),
        ),

        lyrics: (
            timestamp: false,
        ),
    )
  '';

  config = pkgs.writeText "config.ron" ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
        address: "127.0.0.1:6600",
        theme: "tokyonight",
        volume_step: 5,
        max_fps: 30,
        scrolloff: 3,
        enable_mouse: true,
        status_update_interval_ms: 1000,
    )
  '';
in
{
  homix.".config/rmpc/config.ron".source = config;
  homix.".config/rmpc/themes/tokyonight.ron".source = theme;
}
