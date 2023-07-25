
if SERVER then return end

local PANEL = {}

local MARGIN = 2
local NUMBER_WIDTH = 32
local FIX_WIDTH = (NUMBER_WIDTH * 3) + MARGIN * 2

--[[------------------------------------------------------------------
  Creates the editor components.
]]--------------------------------------------------------------------
function PANEL:Init()
  local panel = vgui.Create('DComboBox', self)
  panel:SetTooltip('#hl2hud.menu.hudanimations.command.animate.panel')
  for name, _ in pairs(HL2HUD.elements.All()) do panel:AddChoice(name) end
  panel.OnSelect = function(_, _, option)
    self.Variable:Clear()
    for name, _ in pairs(HL2HUD.elements.Get(option).variables) do
      self.Variable:AddChoice(name)
    end
    self:OnSelectionChanged()
  end
  self.Panel = panel

  local variable = vgui.Create('DComboBox', self)
  variable:SetTooltip('#hl2hud.menu.hudanimations.command.animate.variable')
  variable.OnSelect = function(_, _, option)
    self.Value:Clear()
    self.Value.IsValueValid = function() return true end
    local value = HL2HUD.elements.Get(panel:GetValue()).variables[option]
    local input
    if isnumber(value) then
      input = vgui.Create('DNumberWang', self.Value)
      input:SetMinMax(-9999, 9999)
    elseif IsColor(value) then
      input = vgui.Create('DColorComboBox', self.Value)
      input:SetColors(self.Colors)
      input.OnSelect = function() self:OnSelectionChanged() end
      self.Value.IsValueValid = function() return input:GetSelectedID() ~= nil end
    elseif isvector(value) then
      input = vgui.Create('Panel', self.Value)

        local x = vgui.Create('DNumberWang', input)
        x:SetMinMax(-9999, 9999)
        x:SetTooltip('x')

        local y = vgui.Create('DNumberWang', input)
        y:SetMinMax(-9999, 9999)
        y:SetTooltip('y')

      input.SetValue = function(self, value)
        x:SetValue(value.x)
        y:SetValue(value.y)
      end
      input.GetValue = function(self) return Vector(x:GetValue(), y:GetValue()) end
      input.PerformLayout = function(self, w, h)
        x:SetSize(w * .5 - 1, h)
        y:SetSize(w * .5 - 1, h)
        y:SetX(x:GetWide() + 2)
      end
    end
    input:Dock(FILL)
    self:OnSelectionChanged()
  end
  self.Variable = variable

  local value = vgui.Create('Panel', self)
  value:SetTooltip('#hl2hud.menu.hudanimations.command.animate.value')
  value.GetValue = function(self)
    if self:ChildCount() <= 0 then return end
    return self:GetChild(0):GetValue()
  end
  self.Value = value

  local interp = vgui.Create('DComboBox', self)
  interp:SetTooltip('#hl2hud.menu.hudanimations.command.animate.interpolator')
  interp.OnSelect = function(_, _, option)
    self.Interparam:SetEnabled(debug.getinfo(HL2HUD.animations.GetInterpolators()[option], 'u').nparams >= 2)
    self:OnSelectionChanged()
  end
  for name, _ in pairs(HL2HUD.animations.GetInterpolators()) do interp:AddChoice(name) end
  self.Interp = interp

  local duration = vgui.Create('DNumberWang', self)
  duration:SetTooltip('#hl2hud.menu.hudanimations.command.animate.duration')
  duration:SetWide(NUMBER_WIDTH)
  duration:Dock(RIGHT)
  duration:DockMargin(MARGIN, 0, 0, 0)
  self.Duration = duration

  local delay = vgui.Create('DNumberWang', self)
  delay:SetTooltip('#hl2hud.menu.hudanimations.command.delay')
  delay:SetWide(NUMBER_WIDTH)
  delay:Dock(RIGHT)
  delay:DockMargin(MARGIN, 0, 0, 0)
  self.Delay = delay

  local interparam = vgui.Create('DNumberWang', self)
  interparam:SetTooltip('#hl2hud.menu.hudanimations.command.animate.interpolator_parameter')
  interparam:SetWide(NUMBER_WIDTH)
  interparam:Dock(RIGHT)
  interparam:SetEnabled(false)
  self.Interparam = interparam
end

--[[------------------------------------------------------------------
  Fills the fields with a command's information.
  @param {table} command
]]--------------------------------------------------------------------
function PANEL:PopulateFields(cmd)
  self.Panel:SetText(cmd.panel)
  self.Panel:OnSelect(_, cmd.panel)
  self.Variable:SetText(cmd.variable)
  self.Variable:OnSelect(_, cmd.variable)
  self.Value:GetChild(0):SetValue(cmd.target)
  self.Interp:SetText(cmd.interpolator)
  self.Duration:SetValue(cmd.duration)
  self.Delay:SetValue(cmd.startTime)
  if cmd.interpolatorParam then self.Interparam:SetValue(cmd.interpolatorParam) end
end

--[[------------------------------------------------------------------
  Sets the selectable colours table.
  @param {table} colours to select from
]]--------------------------------------------------------------------
function PANEL:SetColors(colours)
  self.Colors = colours
end

--[[------------------------------------------------------------------
  Returns whether the fields have a valid value.
  @return {boolean} is animation data valid
]]--------------------------------------------------------------------
function PANEL:AreFieldsValid()
  return string.len(self.Panel:GetValue()) > 0 and string.len(self.Variable:GetValue()) > 0 and string.len(self.Interp:GetValue()) > 0 and self.Value:IsValueValid()
end

--[[------------------------------------------------------------------
  Returns a command table based on the fields' values.
  @return {table} command data
]]--------------------------------------------------------------------
function PANEL:GenerateCommandData()
  local cmd = { panel = self.Panel:GetValue(), variable = self.Variable:GetValue(), target = self.Value:GetValue(), interpolator = self.Interp:GetValue(), startTime = self.Delay:GetValue(), duration = self.Duration:GetValue() }
  if self.Interparam:IsEnabled() then cmd.interpolatorParam = self.Interparam:GetValue() end
  return cmd
end

--[[------------------------------------------------------------------
  Called when a combo box value has changed.
]]--------------------------------------------------------------------
function PANEL:OnSelectionChanged() end

--[[------------------------------------------------------------------
  Distributes non numeric components in the remaining space.
]]--------------------------------------------------------------------
function PANEL:PerformLayout(w, h)
  w = w - FIX_WIDTH
  local frac = w / 4
  local x = 0
  for i=0, 3 do
    local panel = self:GetChild(i)
    panel:SetX(x)
    panel:SetSize(frac - MARGIN, h)
    x = x + frac
  end
end

vgui.Register('HL2HUD_AnimationEditor', PANEL, 'Panel')
