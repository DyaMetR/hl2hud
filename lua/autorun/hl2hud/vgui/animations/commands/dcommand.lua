
if SERVER then return end

local PANEL = {}

--[[------------------------------------------------------------------
  Populates the line with the given animation's data.
  @param {table} command
]]--------------------------------------------------------------------
function PANEL:Populate(command)
  self:AddColumn(command.param)
  if command.param2 then self:AddColumn(command.param2) end
  self:AddColumn(command.startTime, '#hl2hud.menu.hudanimations.command.delay')
end

vgui.Register('HL2HUD_CommandLine_Generic', PANEL, 'HL2HUD_CommandLine')
