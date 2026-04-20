{ pkgs, ... }:
let
  helixConfig = (pkgs.formats.toml { }).generate "config.toml" {
    theme = "tokyonight";
    editor = {
      bufferline = "multiple";
      end-of-line-diagnostics = "hint";
      file-picker = {
        git-ignore = true;
      };
      indent-guides = {
        render = true;
        character = "▏";
        skip-levels = 1;
      };
      statusline = {
        left = [
          "mode"
          "spinner"
          "version-control"
          "file-name"
        ];
        center = [ ];
        right = [
          "diagnostics"
          "selections"
          "file-encoding"
          "file-type"
          "position"
          "position-percentage"
        ];
        separator = "│";
        mode.normal = "NORMAL";
        mode.insert = "INSERT";
        mode.select = "SELECT";
      };
      soft-wrap = {
        enable = true;
        max-wrap = 25;
        max-indent-retain = 0;
        wrap-indicator = "";
      };
      inline-diagnostics = {
        cursor-line = "warning";
      };
    };
    keys.normal = {
      "C-right" = ":bn";
      "C-left" = ":bp";
      "C-x" = ":bc";
    };
  };
  helixLanguages = (pkgs.formats.toml { }).generate "languages.toml" {
    language = [
      {
        name = "go";
        language-servers = [
          "gopls"
          "golangci-lint-langserver"
        ];
        formatter = {
          command = "goimports";
        };
        auto-format = true;
      }
      {
        name = "nix";
        formatter = {
          command = "nixfmt";
        };
        auto-format = true;
      }
    ];

    language-server = {
      gopls = {
        command = "gopls";
      };
      golangci-lint-langserver = {
        command = "golangci-lint-langserver";
        config.command = [
          "golangci-lint"
          "run"
          "--output.json.path"
          "stdout"
          "--show-stats=false"
          "--issues-exit-code=0"
        ];
      };
    };
  };
in
{
  environment.systemPackages = [ pkgs.helix ];
  homix.".config/helix/config.toml".source = helixConfig;
  homix.".config/helix/languages.toml".source = helixLanguages;
}
