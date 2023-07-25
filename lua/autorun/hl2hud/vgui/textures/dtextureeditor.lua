
if SERVER then return end

local PANEL = {}

local EDITORS = {
  [HL2HUD.scheme.ICON_FONT] = 'HL2HUD_IconEditor',
  [HL2HUD.scheme.ICON_SPRITE] = 'HL2HUD_SpriteEditor'
}

local CHOICES = {
  [HL2HUD.scheme.ICON_FONT] = '#hl2hud.menu.hudtextures.properties.type.icon',
  [HL2HUD.scheme.ICON_SPRITE] = '#hl2hud.menu.hudtextures.properties.type.sprite'
}

function PANEL:Init()
  self:DockMargin(2, 2, 2, 2)

  local selector = vgui.Create('DComboBox', self)
  selector:SetWide(96)
  selector:Dock(LEFT)
  selector:DockMargin(0, 0, 2, 0)
  selector:AddChoice(CHOICES[HL2HUD.scheme.ICON_FONT], nil, nil, 'icon16/style.png')
  selector:AddChoice(CHOICES[HL2HUD.scheme.ICON_SPRITE], nil, nil, 'icon16/picture.png')
  selector.OnSelect = function(_, i) self:CreateEditor(EDITORS[i]) end
  self.IconType = selector

  local class = vgui.Create('DTextEntry', self)
  class:SetWide(128)
  class:Dock(LEFT)
  class:DockMargin(0, 0, 2, 0)
  class.OnChange = function() self:OnValueChanged() end
  self.ClassInput = class

  selector:ChooseOption(CHOICES[HL2HUD.scheme.ICON_FONT], HL2HUD.scheme.ICON_FONT)
end

--[[------------------------------------------------------------------
  Creates an editor control, replacing the old one (if any).
  @param {string} editor class
]]--------------------------------------------------------------------
function PANEL:CreateEditor(editor)
  if self.Editor then self.Editor:Remove() end
  self.Editor = vgui.Create(editor, self)
  self.Editor:Dock(FILL)
  self.Editor.OnValueChanged = function() self:OnValueChanged() end
end

--[[------------------------------------------------------------------
  Sets the placeholder text shown in the class text entry.
  @param {string} placeholder text
]]--------------------------------------------------------------------
function PANEL:SetClassPlaceholder(placeholder)
  self.ClassInput:SetPlaceholderText(placeholder)
end

--[[------------------------------------------------------------------
  Removes the ability to edit the class.
]]--------------------------------------------------------------------
function PANEL:MakeClassReadOnly()
  self.ClassInput:SetEditable(false)
  self.ClassInput:SetPaintBackground(false)
  self.ClassInput.OnChange = function() end
end

--[[------------------------------------------------------------------
  Hydrates the control with the given icon data.
  @param {string} class
  @param {table} icon data
]]--------------------------------------------------------------------
function PANEL:SetIconData(class, data)
  self.ClassInput:SetText(class)
  self.IconType:ChooseOption(CHOICES[data.type], data.type)
  self.Editor:SetIconData(data)
end

--[[------------------------------------------------------------------
  Returns what is this icon supposed to be for.
  @return {string} icon target class
]]--------------------------------------------------------------------
function PANEL:GetClass()
  return self.ClassInput:GetText()
end

--[[------------------------------------------------------------------
  Generates the icon data depending on the current control values.
  @return {string} class to be used as index
  @return {table} generated icon data
]]--------------------------------------------------------------------
function PANEL:GenerateIconData()
  local data = self.Editor:GenerateIconData()
  data.type = self.IconType:GetSelectedID()
  return self:GetClass(), data
end

--[[------------------------------------------------------------------
  Sets the font table used when populating the font selector.
  @param {table} fonts
]]--------------------------------------------------------------------
function PANEL:SetFontSource(fonts)
  self.Fonts = fonts
  if self.Editor.Font then self.Editor:PopulateFonts(self.Fonts) end
end

--[[------------------------------------------------------------------
  Returns whether the data present is valid.
  @return {boolean} is it valid
]]--------------------------------------------------------------------
function PANEL:Validated()
  return string.len(self:GetClass()) > 0 and self.Editor:Validated()
end

--[[------------------------------------------------------------------
  Called when a value within the controls is changed.
]]--------------------------------------------------------------------
function PANEL:OnValueChanged() end

vgui.Register('HL2HUD_TextureEditor', PANEL, 'HL2HUD_ButtonedLine')
