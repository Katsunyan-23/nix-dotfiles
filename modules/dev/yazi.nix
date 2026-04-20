{ pkgs, ... }:

let
  yaziConfigFile = (pkgs.formats.toml { }).generate "yazi.toml" {
    manager = {
      ratio = [
        1
        2
        4
      ];
      sort-by = "natural";
      sort-sensitive = false;
      sort-reverse = false;
      sort-dir-first = true;
      linemode = "size";
      show-hidden = false;
      show-symlink = true;
    };

    preview = {
      tab-size = 2;
      max-width = 1920;
      max-height = 1080;
      cache-dir = "";
      image-filter = "lanczos3";
      image-quality = 75;
    };

    opener = {
      edit = [
        {
          run = ''$EDITOR "$@"'';
          block = true;
          for = "unix";
        }
      ];
      open = [
        {
          run = ''xdg-open "$@"'';
          for = "linux";
        }
      ];
      reveal = [
        {
          run = ''xdg-open "$(dirname "$0")"'';
          for = "linux";
        }
      ];
      extract = [
        {
          run = ''unar "$1"'';
          desc = "Extract here";
        }
      ];
      play = [
        {
          run = ''mpv "$@"'';
          orphan = true;
        }
      ];
    };

    open.rules = [
      {
        mime = "text/*";
        use = "edit";
      }
      {
        mime = "image/*";
        use = "open";
      }
      {
        mime = "video/*";
        use = "play";
      }
      {
        mime = "audio/*";
        use = "play";
      }
      {
        mime = "application/zip";
        use = "extract";
      }
      {
        mime = "application/gzip";
        use = "extract";
      }
      {
        mime = "application/x-tar";
        use = "extract";
      }
      {
        mime = "inode/x-empty";
        use = "edit";
      }
      {
        mime = "*";
        use = "open";
      }
    ];

    tasks = {
      micro-workers = 10;
      macro-workers = 25;
      bizarre-retry = 5;
      image-alloc = 536870912;
    };

    plugin = {
      fetchers = [
        {
          id = "mime";
          name = "{file}";
          run = "mime";
          "if" = "!mime";
          prio = "high";
        }
      ];
      preloaders = [
        {
          mime = "image/*";
          run = "image";
        }
      ];
      previewers = [
        {
          name = "*/";
          run = "folder";
        }
        {
          mime = "text/*";
          run = "code";
        }
        {
          mime = "image/*";
          run = "image";
        }
        {
          mime = "video/*";
          run = "video";
        }
        {
          mime = "application/json";
          run = "json";
        }
        {
          mime = "application/pdf";
          run = "pdf";
        }
        {
          mime = "*";
          run = "file";
        }
      ];
    };

    input.cursor-blink = false;
  };

in
{
  environment.systemPackages = [ pkgs.yazi ];

  homix.".config/yazi/yazi.toml".source = yaziConfigFile;
}
