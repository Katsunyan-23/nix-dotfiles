{ config, lib, pkgs, ... }:

let
  username = config.system.primaryUser;
  homeDir = "/Users/${username}";

  linkLines = lib.mapAttrsToList (
    relPath: entry:
    let
      target = "${homeDir}/${relPath}";
    in
    ''
      mkdir -p "$(dirname "${target}")"
      ln -sfn "${entry.source}" "${target}"
      chown ${username} "${target}"
    ''
  ) config.homix;

  linkScript = pkgs.writeShellScript "darwin-homix-link" ''
    set -euo pipefail
    ${lib.concatStringsSep "\n" linkLines}
  '';
in
{
  options.homix = lib.mkOption {
    default = { };
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, config, ... }:
        {
          options.source = lib.mkOption {
            type = lib.types.path;
          };
          options.text = lib.mkOption {
            default = null;
            type = lib.types.nullOr lib.types.lines;
          };
          config.source = lib.mkIf (config.text != null) (
            pkgs.writeText ("darwin-homix-" + lib.replaceStrings [ "/" ] [ "-" ] name) config.text
          );
        }
      )
    );
  };

  config.system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "homix: linking config files for ${username}..."
    ${linkScript}
  '';
}
