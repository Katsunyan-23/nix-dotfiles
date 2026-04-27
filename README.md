# General nix config for both a Mac and NixOS machine

Sharing config leveraging nix-darwin to enable the nix-style config on Mac (even if it requires a lot of wiggling)

# Structure

For now the config is very basic, most programs shares the same config on both OS and can be used as is

Some like MPD requires additional config depending on the OS

Changes are not always fully tested. It might break on one OS and need more fixing

# Issues

For my setup, it is not possible to configure audio natively (or at least easily). The setup requires audio to go through the monitor over HDMI (which is fine on most systems). MacOS does not like this and disable the ability to change volume completely. The workaround for now is to set up MDP to play through sox. Then uses Boom3D(paid - not included in config) to handle volume changing. Might switch later if I can find a good alternative
