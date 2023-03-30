
if SERVER then return end

local PANEL = {}

local LOCALE_DELAY    = 'Delay'

--[[------------------------------------------------------------------
  Populates the line with the given animation's data.
  @param {table} command
]]--------------------------------------------------------------------
function PANEL:Populate(command)
  self:AddColumn(command.param)
  if command.param2 then self:AddColumn(command.param2) end
  self:AddColumn(command.startTime, LOCALE_DELAY)
end

vgui.Register('HL2HUD_CommandLine_Generic', PANEL, 'HL2HUD_CommandLine')