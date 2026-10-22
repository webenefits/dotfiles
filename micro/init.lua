-- dotfiles: micro init.lua (→ ~/.config/micro/init.lua)

local micro = import("micro")
local config = import("micro/config")

-- F9 / command "togglemouse": toggle mouse capture so the terminal can select
-- text itself (like nano). Unlike "toggle mouse", this does not write
-- settings.json, so the managed file stays untouched and the next start has
-- the mouse enabled again.
function init()
    config.MakeCommand("togglemouse", togglemouse, config.NoComplete)
    config.TryBindKey("F9", "lua:initlua.togglemouse", false)
end

function togglemouse(bp)
    local on = not config.GetGlobalOption("mouse")
    config.SetGlobalOptionNative("mouse", on)
    if on then
        micro.InfoBar():Message("Mouse on (micro selection)")
    else
        micro.InfoBar():Message("Mouse off (terminal selection, F9 to re-enable)")
    end
end
