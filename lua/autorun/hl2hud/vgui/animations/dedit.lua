
if SERVER then return end

local PANEL = {}

local COLOUR = Color(255, 255, 215)

local LOCALE_REMOVE   = 'Remove animation command'
local LOCALE_APPLY    = 'Apply changes'
local LOCALE_UNDO     = 'Cancel'

--[[------------------------------------------------------------------
  Creates the command type label and the buttons.
]]--------------------------------------------------------------------
function PANEL:Init()
  local label = vgui.Create('DLabel', self)
  label:Dock(LEFT)
  label:DockMargin(5, 0, 0, 0)
  label:SetTextColor(self:GetSkin().text_dark)
  self.Label = label

  local apply = self:AddButton('icon16/accept.png', LOCALE_APPLY)
  apply.DoClick = function()
    self:DoApply()
    self:Remove()
  end
  self.Apply = apply

  self:AddButton('icon16/delete.png', LOCALE_REMOVE).DoClick = function()
    self:DoRemove()
    self:Remove()
  end

  self:AddButton('icon16/arrow_undo.png', LOCALE_UNDO).DoClick = function() self:Remove() end
end

--[[------------------------------------------------------------------
  Changes the label's text.
  @param {string} text
]]--------------------------------------------------------------------
function PANEL:SetText(text)
  self.Label:SetText(text)
end

--[[------------------------------------------------------------------
  Changes whether the apply button can be pressed.
  @param {boolean} is apply button enabled
]]--------------------------------------------------------------------
function PANEL:SetCanApply(enabled)
  self.Apply:SetEnabled(enabled)
end

--[[------------------------------------------------------------------
  Paints everything as if it was a DTextEntry.
]]--------------------------------------------------------------------
function PANEL:Paint()
  local skin = self:GetSkin()
  draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), skin.colTextEntryBorder)
  draw.RoundedBox(0, 1, 1, self:GetWide() - 2, self:GetTall() - 2, COLOUR)
end

--[[------------------------------------------------------------------
  Resize label.
]]--------------------------------------------------------------------
function PANEL:PerformLayout(w, h)
  self.Label:SetWide(math.max(w / 8, 64))
end

--[[------------------------------------------------------------------
  Called when the remove button is pressed.
]]--------------------------------------------------------------------
function PANEL:DoRemove() end

--[[------------------------------------------------------------------
  Called when the apply button is pressed.
]]--------------------------------------------------------------------
function PANEL:DoApply() end

vgui.Register('HL2HUD_CommandLineEdit', PANEL, 'HL2HUD_ButtonedLine')