{ pkgs, ... }:

let
  initLua = pkgs.writeText "init.lua" ''
    hs.hotkey.bind({"ctrl", "alt"}, "t", function()
      hs.application.launchOrFocus("kitty")
    end)
  '';
in
{
  homix.".hammerspoon/init.lua".source = initLua;
}
