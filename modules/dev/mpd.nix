{ ... }:
{
  services.mpd = {
    enable = true;
    user = "katsunyan";
    musicDirectory = "/home/katsunyan/Music";
    network.listenAddress = "127.0.0.1";
    network.port = 6600;
    extraConfig = ''
      audio_output {
        type    "pipewire"
        name    "PipeWire"
      }
    '';
  };

  # MPD needs the user's pipewire socket via XDG_RUNTIME_DIR
  systemd.services.mpd.environment.XDG_RUNTIME_DIR = "/run/user/1000";
}
