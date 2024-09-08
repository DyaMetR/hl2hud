
if SERVER then return end

local PANEL = {}

local LABEL_WIDTH = 148
local LABEL_MARGIN = 5

--[[------------------------------------------------------------------
  Creates the label and font editor.
]]--------------------------------------------------------------------
function PANEL:Init()
  local label = vgui.Create('DLabel', self)
  label:SetWide(LABEL_WIDTH)
  label:Dock(LEFT)
  label:DockMargin(LABEL_MARGIN, 0, 0, 0)
  label:SetTextColor(self:GetSkin().Colours.Label.Dark)
  self.Label = label

  local editor = vgui.Create('HL2HUD_FontEditor', self)
  editor:Dock(FILL)
  editor.OnValueChanged = function() self:OnValueChanged(editor:GenerateFontData()) end
  self.Editor = editor
end

--[[------------------------------------------------------------------
  Sets the editor's font properties.
  @param {string} font
  @param {number} size
  @param {number} weight
  @param {boolean} additive
  @param {number} blur size
  @param {number} scanlines gap
  @param {boolean} enable symbolic fonts
  @param {boolean} is it scalable
  @param {boolean} antialias
]]--------------------------------------------------------------------
function PANEL:SetFont(font, size, weight, additive, blur, scanlines, symbol, scalable, antialias)
  self.Editor:SetFont(font, size, weight, additive, blur, scanlines, symbol, scalable, antialias)
end

--[[------------------------------------------------------------------
  Sets the label's contents.
  @param {string} text
]]--------------------------------------------------------------------
function PANEL:SetText(text)
  self.Label:SetText(text)
end

--[[------------------------------------------------------------------
  Called when the editor's values change.
  @param {table} generated font data
]]--------------------------------------------------------------------
function PANEL:OnValueChanged(data) end

vgui.Register('HL2HUD_FontResource', PANEL, 'HL2HUD_ButtonedLine')
