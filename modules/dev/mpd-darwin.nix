{ pkgs, lib, config, ... }:
let
  user = config.system.primaryUser;
  home = "/Users/${user}";

  mpdConf = pkgs.writeText "mpd.conf" ''
    music_directory    "~/Music"
    db_file            "~/.local/share/mpd/database"
    log_file           "~/.local/share/mpd/log"
    pid_file           "~/.local/share/mpd/pid"
    state_file         "~/.local/share/mpd/state"

    bind_to_address    "127.0.0.1"
    port               "6600"

    audio_output {
      type    "osx"
      name    "CoreAudio"
    }
  '';
in
{
  homix.".config/mpd/mpd.conf".source = mpdConf;

  system.activationScripts.postActivation.text = lib.mkAfter ''
    sudo -u ${user} mkdir -p ${home}/.local/share/mpd
    sudo -u ${user} mkdir -p ${home}/Music
  '';

  launchd.user.agents.mpd = {
    serviceConfig = {
      ProgramArguments = [ "${pkgs.mpd}/bin/mpd" "--no-daemon" "--stderr" "${mpdConf}" ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/mpd.log";
      StandardErrorPath = "/tmp/mpd.log";
    };
  };
}
