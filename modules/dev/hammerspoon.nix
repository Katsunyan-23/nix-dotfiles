{ pkgs, ... }:

let
  initLua = pkgs.writeText "init.lua" ''
    hs.hotkey.bind({"ctrl", "command"}, "t", function()
      hs.application.launchOrFocus("kitty")
    end)

    local excluded = { "kitty", "iTerm2", "Terminal" }

    local function isExcluded()
      local appName = hs.application.frontmostApplication():name()
      for _, name in ipairs(excluded) do
        if appName == name then return true end
      end
      return false
    end

    local ctrlKeys = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
      local mods = e:getFlags()
      local key = hs.keycodes.map[e:getKeyCode()]

      if mods.ctrl and not mods.cmd and not mods.alt and not isExcluded() then
        if key == "c" then
          hs.eventtap.keyStroke({"cmd"}, "c")
          return true -- consume original keystroke
        elseif key == "v" then
          hs.eventtap.keyStroke({"cmd"}, "v")
          return true
        end
      end

      if mods.ctrl and mods.shift then
        if key == "c" then
          hs.eventtap.keyStroke({"cmd"}, "c")
          return true
        elseif key == "v" then
           hs.eventtap.keyStroke({"cmd"}, "v")
          return true
        end
      end
    end)

    local cmdToAlt = hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(e)
      local mods = e:getFlags()
      local key = hs.keycodes.map[e:getKeyCode()]
      local app = hs.application.frontmostApplication():name()

      if app == "kitty" and mods.cmd and not mods.ctrl and not mods.shift then
        hs.eventtap.keyStroke({"alt"}, key)
        return true
      end
    end)

    ctrlKeys:start()

  '';
in
{
  homix.".hammerspoon/init.lua".source = initLua;
}
