if SERVER then return end

local UID = 'hl2hud'
local ICON = 'hl2hud/icon64.png'

local LOCALE_TITLE  = 'Scheme Settings'

-- create desktop widget to access the editor
list.Set('DesktopWindows', UID, {
  title = LOCALE_TITLE,
  icon = ICON,
  init = function() RunConsoleCommand('hl2hud_menu') end
})
