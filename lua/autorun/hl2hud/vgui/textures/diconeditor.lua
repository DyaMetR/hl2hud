
if SERVER then return end

local DEFAULT_FONT  = 'WeaponIcons'
local MARGIN        = 2

local PANEL = {}

function PANEL:Init()
  local font = vgui.Create('DComboBox', self)
  font:SetTooltip('#hl2hud.menu.hudtextures.properties.font')
  font:SetText(DEFAULT_FONT)
  font.OnSelect = function() self:OnValueChanged() end
  self.Font = font

  local icon = vgui.Create('DTextEntry', self)
  icon:SetPlaceholderText('#hl2hud.menu.hudtextures.properties.character')
  icon:SetUpdateOnType(true)
  icon.OnValueChange = function() self:OnValueChanged() end
  self.Icon = icon

  local x = vgui.Create('DNumberWang', self)
  x:SetTooltip('#hl2hud.menu.hudtextures.properties.x')
  x:SetMinMax(-9999, 9999)
  x.OnValueChanged = function() self:OnValueChanged() end
  self.XOff = x

  local y = vgui.Create('DNumberWang', self)
  y:SetTooltip('#hl2hud.menu.hudtextures.properties.y')
  y:SetMinMax(-9999, 9999)
  y.OnValueChanged = function() self:OnValueChanged() end
  self.YOff = y
end

function PANEL:PerformLayout(w, h)
  local x = 0
  local size = w / self:ChildCount()
  for i, child in pairs(self:GetChildren()) do
    child:SetX(x)
    child:SetSize(size - MARGIN, h)
    x = x + size
  end
end

--[[------------------------------------------------------------------
  Populates the fonts selector.
  @param {table} fonts
]]--------------------------------------------------------------------
function PANEL:PopulateFonts(fonts)
  for name, _ in pairs(fonts) do
    self.Font:AddChoice(name)
  end
end

--[[------------------------------------------------------------------
  Hydrates the controls with the given icon data.
  @param {table} icon data
]]--------------------------------------------------------------------
function PANEL:SetIconData(data)
  self.Font:SetText(data.font)
  self.Icon:SetText(data.icon)
  self.XOff:SetValue(data.x or 0)
  self.YOff:SetValue(data.y or 0)
end

--[[------------------------------------------------------------------
  Creates a table with the icon data.
  @return {table} icon data
]]--------------------------------------------------------------------
function PANEL:GenerateIconData()
  return {
    font = self.Font:GetText(),
    icon = self.Icon:GetText(),
    x = self.XOff:GetValue(),
    y = self.YOff:GetValue()
  }
end

--[[------------------------------------------------------------------
  Returns whether the data present is valid.
  @return {boolean} is it valid
]]--------------------------------------------------------------------
function PANEL:Validated()
  return string.len(self.Font:GetText()) and string.len(self.Icon:GetText()) > 0
end

--[[------------------------------------------------------------------
  Called when a value is changed.
]]--------------------------------------------------------------------
function PANEL:OnValueChanged() end

vgui.Register('HL2HUD_IconEditor', PANEL, 'Panel')
