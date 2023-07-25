
if SERVER then return end

local PANEL = {}

local FORMAT_VECTOR = '(x = %i, y = %i)'

--[[------------------------------------------------------------------
  Populates the line with the given animation's data.
  @param {table} command
]]--------------------------------------------------------------------
function PANEL:Populate(command)
  local target = command.target
  if isvector(target) then target = string.format(FORMAT_VECTOR, target.x, target.y) end
  self:AddColumn(command.panel, '#hl2hud.menu.hudanimations.command.animate.panel')
  self:AddColumn(command.variable, '#hl2hud.menu.hudanimations.command.animate.variable')
  self:AddColumn(target, '#hl2hud.menu.hudanimations.command.animate.value')
  self:AddColumn(command.interpolator, '#hl2hud.menu.hudanimations.command.animate.interpolator')
  if command.interpolatorParam then self:AddColumn(command.interpolatorParam, '#hl2hud.menu.hudanimations.command.animate.interpolator_parameter') end
  self:AddColumn(command.startTime, '#hl2hud.menu.hudanimations.command.delay')
  self:AddColumn(command.duration, '#hl2hud.menu.hudanimations.command.animate.duration')
end

vgui.Register('HL2HUD_CommandLine_Animation', PANEL, 'HL2HUD_CommandLine')
