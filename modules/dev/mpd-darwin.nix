{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = config.system.primaryUser;
  home = "/Users/${user}";

  mpdConf = pkgs.writeText "mpd.conf" ''
    music_directory    "~/Music"
    playlist_directory "~/.local/share/mpd/playlists"
    db_file            "~/.local/share/mpd/database"
    log_file           "~/.local/share/mpd/log"
    pid_file           "~/.local/share/mpd/pid"
    state_file         "~/.local/share/mpd/state"

    bind_to_address    "127.0.0.1"
    port               "6600"

    log_level "verbose"

    audio_output {
      type    "pipe"
      name    "CoreAudio via pipe"
      command "${pkgs.sox}/bin/sox -t raw -r 48000 -e signed-integer -b 16 -c 2 - -d"
      format  "48000:16:2"
      mixer_type  "software"
    }
  '';
in
{
  homix.".config/mpd/mpd.conf".source = mpdConf;

  system.activationScripts.postActivation.text = lib.mkAfter ''
    sudo -u ${user} mkdir -p ${home}/.local/share/mpd
    sudo -u ${user} mkdir -p ${home}/.local/share/mpd/playlists
    sudo -u ${user} mkdir -p ${home}/Music
  '';

  launchd.user.agents.mpd = {
    serviceConfig = {
      ProgramArguments = [
        "${pkgs.mpd}/bin/mpd"
        "--no-daemon"
        "--stderr"
        "${mpdConf}"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/mpd.log";
      StandardErrorPath = "/tmp/mpd.log";
    };
  };
}
