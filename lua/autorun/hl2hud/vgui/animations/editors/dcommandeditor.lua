
if SERVER then return end

local PANEL = {}

local MARGIN = 2

local LOCALE_DELAY    = 'Delay'

--[[------------------------------------------------------------------
  Creates the editor components.
]]--------------------------------------------------------------------
function PANEL:Init()
  self.Param = vgui.Create('DComboBox', self)

  local delay = vgui.Create('DNumberWang', self)
  delay:SetTooltip(LOCALE_DELAY)
  self.Delay = delay
end

--[[------------------------------------------------------------------
  Adds the secondary parameter combo box.
]]--------------------------------------------------------------------
function PANEL:AddParam2()
  local param2 = vgui.Create('DComboBox', self)
  param2.OnSelect = function() self:OnSelectionChanged() end
  self.Param2 = param2
end

--[[------------------------------------------------------------------
  Populates the contents with the given command type information.
  @param {string} command type
  @param {table} current scheme data
]]--------------------------------------------------------------------
function PANEL:Populate(commandType, scheme)
  local data = HL2HUD.animations.GetCommandTypes()[commandType]
  for option, _ in pairs(data.options(scheme)) do
    self.Param:AddChoice(option)
  end
  self.Param.OnSelect = function(_, _, element)
    self:OnSelectionChanged()
    if not data.optional then return end
    self.Param2:Clear()
    for option, _ in pairs(data.optional(element)) do
      self.Param2:AddChoice(option)
    end
  end
end

--[[------------------------------------------------------------------
  Fills the fields with a command's information.
  @param {table} command
]]--------------------------------------------------------------------
function PANEL:PopulateFields(cmd)
  self.Delay:SetText(cmd.startTime)
  self.Param:SetText(cmd.param)
  if not cmd.param2 then return end
  self.Param:OnSelect(_, cmd.param)
  self.Param2:SetText(cmd.param2)
end

--[[------------------------------------------------------------------
  Returns whether the fields have a valid value.
  @return {boolean} is animation data valid
]]--------------------------------------------------------------------
function PANEL:AreFieldsValid()
  return string.len(self.Param:GetValue()) > 0 and (not self.Param2 or string.len(self.Param2:GetValue()) > 0)
end

--[[------------------------------------------------------------------
  Returns a command table based on the fields' values.
  @return {table} command data
]]--------------------------------------------------------------------
function PANEL:GenerateCommandData()
  local cmd = { param = self.Param:GetValue(), startTime = self.Delay:GetValue() }
  if self.Param2 then cmd.param2 = self.Param2:GetValue() end
  return cmd
end

--[[------------------------------------------------------------------
  Called when a combo box value has changed.
]]--------------------------------------------------------------------
function PANEL:OnSelectionChanged() end

--[[------------------------------------------------------------------
  Evenly distribute components.
]]--------------------------------------------------------------------
function PANEL:PerformLayout(w, h)
  local size = w / self:ChildCount()
  self.Param:SetSize(size - MARGIN, h)
  self.Delay:SetSize(size, h)
  if self.Param2 then
    self.Param2:SetSize(size - MARGIN, h)
    self.Param2:SetX(size)
    self.Delay:SetX(size * 2)
  else
    self.Delay:SetX(size)
  end
end

vgui.Register('HL2HUD_CommandEditor', PANEL, 'Panel')
