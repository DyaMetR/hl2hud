
if SERVER then return end

local PANEL = {}

local FORMAT_VECTOR = '(x = %i, y = %i)'

local LOCALE_PANEL    = 'Element'
local LOCALE_VARIABLE = 'Variable'
local LOCALE_VALUE    = 'Value'
local LOCALE_INTERP   = 'Interpolator'
local LOCALE_PARAM    = 'Interpolator parameter'
local LOCALE_DELAY    = 'Delay'
local LOCALE_DURATION = 'Duration'

--[[------------------------------------------------------------------
  Populates the line with the given animation's data.
  @param {table} command
]]--------------------------------------------------------------------
function PANEL:Populate(command)
  local target = command.target
  if isvector(target) then target = string.format(FORMAT_VECTOR, target.x, target.y) end
  self:AddColumn(command.panel, LOCALE_PANEL)
  self:AddColumn(command.variable, LOCALE_VARIABLE)
  self:AddColumn(target, LOCALE_VALUE)
  self:AddColumn(command.interpolator, LOCALE_INTERP)
  if command.interpolatorParam then self:AddColumn(command.interpolatorParam, LOCALE_PARAM) end
  self:AddColumn(command.startTime, LOCALE_DELAY)
  self:AddColumn(command.duration, LOCALE_DURATION)
end

vgui.Register('HL2HUD_CommandLine_Animation', PANEL, 'HL2HUD_CommandLine')