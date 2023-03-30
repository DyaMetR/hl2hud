
if SERVER then return end

local PANEL = {}

local BUTTON_WIDTH  = 96
local BUTTON_HEIGHT = 20
local BUTTON_MARGIN = 2
local LABEL_MARGIN  = 5

--[[------------------------------------------------------------------
  Creates the colour button and label.
]]--------------------------------------------------------------------
function PANEL:Init()
  local colour = vgui.Create('DColorMixerButton', self)
  colour:SetSize(BUTTON_WIDTH, BUTTON_HEIGHT)
  colour:SetPos(BUTTON_MARGIN, BUTTON_MARGIN)
  colour.OnValueChanged = function(_, value) self:OnValueChanged(value) end
  self.Colour = colour

  local label = vgui.Create('DLabel', self)
  label:SetPos(self.Colour:GetX() + self.Colour:GetWide() + LABEL_MARGIN, LABEL_MARGIN)
  label:SetTextColor(self:GetSkin().text_dark)
  self.Label = label
end

--[[------------------------------------------------------------------
  Sets the text of the label.
  @param {string} text
]]--------------------------------------------------------------------
function PANEL:SetText(text)
  self.Label:SetText(text)
  self.Label:SizeToContents()
end

--[[------------------------------------------------------------------
  Sets the colour mixer value.
  @param {Color} value
]]--------------------------------------------------------------------
function PANEL:SetValue(value)
  self.Colour.Value = value
end

--[[------------------------------------------------------------------
  Called when the colour mixer value changes.
  @param {Color} value
]]--------------------------------------------------------------------
function PANEL:OnValueChanged(value) end

vgui.Register('HL2HUD_ColorResource', PANEL, 'HL2HUD_ButtonedLine')
