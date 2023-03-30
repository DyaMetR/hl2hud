
if SERVER then return end

local MARGIN = 2

local LOCALE_TEXTURE  = 'Texture'
local LOCALE_W        = 'Texture file width'
local LOCALE_H        = 'Texture file height'
local LOCALE_U1       = 'Sprite\'s left side (leave at 0 for default)'
local LOCALE_V1       = 'Sprite\'s top side (leave at 0 for default)'
local LOCALE_U2       = 'Sprite\'s right side (leave at 0 for default)'
local LOCALE_V2       = 'Sprite\'s bottom side (leave at 0 for default)'
local LOCALE_XOFF     = 'Horizontal offset'
local LOCALE_YOFF     = 'Vertical offset'
local LOCALE_SCALABLE = 'Scaled'

local PANEL = {}

--[[------------------------------------------------------------------
  Adds a number wang with default properties and returns it.
  @param {Panel} parent panel
  @param {string} locale
  @return {Panel} panel
]]--------------------------------------------------------------------
local function AddNumberWang(parent, locale)
  local panel = vgui.Create('DNumberWang', parent)
  panel:Dock(LEFT)
  panel:DockMargin(0, 0, 2, 0)
  panel:SetWide(32)
  panel:SetTooltip(locale)
  panel:SetMinMax(0, 9999)
  panel.OnValueChanged = function() parent:GetParent():OnValueChanged() end
  return panel
end

function PANEL:Init()
  local texture = vgui.Create('DTextEntry', self)
  texture:SetPlaceholderText(LOCALE_TEXTURE)
  texture:Dock(FILL)
  texture:DockMargin(0, 0, 2, 0)
  texture:SetUpdateOnType(true)
  texture.OnValueChange = function() self:OnValueChanged() end
  self.Texture = texture

  local controls = vgui.Create('Panel', self)
  controls:SetWide(326)
  controls:Dock(RIGHT)

    self.FW = AddNumberWang(controls, LOCALE_W)
    self.FH = AddNumberWang(controls, LOCALE_H)
    self.U1 = AddNumberWang(controls, LOCALE_U1)
    self.V1 = AddNumberWang(controls, LOCALE_V1)
    self.U2 = AddNumberWang(controls, LOCALE_U2)
    self.V2 = AddNumberWang(controls, LOCALE_V2)
    self.XOff = AddNumberWang(controls, LOCALE_XOFF)
    self.XOff:SetMin(-9999)
    self.YOff = AddNumberWang(controls, LOCALE_YOFF)
    self.YOff:SetMin(-9999)

    local scalable = vgui.Create('DCheckBoxLabel', controls)
    scalable:SetWide(64)
    scalable:Dock(LEFT)
    scalable:SetText(LOCALE_SCALABLE)
    scalable:SetTextColor(self:GetSkin().text_dark)
    scalable:SetChecked(true)
    scalable.OnChange = function() self:OnValueChanged() end
    self.Scalable = scalable
end

--[[------------------------------------------------------------------
  Hydrates the controls with the given icon data.
  @param {table} icon data
]]--------------------------------------------------------------------
function PANEL:SetIconData(data)
  local scalable = data.scalable
  if scalable == nil then scalable = true end
  self.Texture:SetText(surface.GetTextureNameByID(data.texture))
  self.FW:SetValue(data.w)
  self.FH:SetValue(data.h)
  self.U1:SetValue(data.u1 or 0)
  self.V1:SetValue(data.v1 or 0)
  self.U2:SetValue(data.u2 or 0)
  self.V2:SetValue(data.v2 or 0)
  self.XOff:SetValue(data.x or 0)
  self.YOff:SetValue(data.y or 0)
  self.Scalable:SetChecked(scalable)
end

--[[------------------------------------------------------------------
  Creates a table with the icon data.
  @return {table} icon data
]]--------------------------------------------------------------------
function PANEL:GenerateIconData()
  local u2, v2 = self.U2:GetValue(), self.V2:GetValue()
  if u2 == 0 then u2 = self.FW:GetValue() end
  if v2 == 0 then v2 = self.FH:GetValue() end
  return {
    texture = surface.GetTextureID(self.Texture:GetText()),
    w = self.FW:GetValue(),
    h = self.FH:GetValue(),
    u1 = self.U1:GetValue(),
    v1 = self.V1:GetValue(),
    u2 = u2,
    v2 = v2,
    x = self.XOff:GetValue(),
    y = self.YOff:GetValue(),
    scalable = self.Scalable:GetChecked()
  }
end

--[[------------------------------------------------------------------
  Returns whether the data present is valid.
  @return {boolean} is it valid
]]--------------------------------------------------------------------
function PANEL:Validated()
  return string.len(self.Texture:GetText()) > 0 and self.FW:GetValue() > 0 and self.FH:GetValue() > 0
end

--[[------------------------------------------------------------------
  Called when a value is changed.
]]--------------------------------------------------------------------
function PANEL:OnValueChanged() end

vgui.Register('HL2HUD_SpriteEditor', PANEL, 'Panel')
