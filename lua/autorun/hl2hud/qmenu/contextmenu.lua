if SERVER then return end

local UID = 'hl2hud'
local ICON = 'hl2hud/icon64.png'

-- create desktop widget to access the editor
list.Set('DesktopWindows', UID, {
  title = '#hl2hud.context.widget',
  icon = ICON,
  init = function() RunConsoleCommand('hl2hud_menu') end
})
