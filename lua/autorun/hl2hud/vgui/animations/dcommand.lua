
if SERVER then return end

local PANEL = {}

--[[------------------------------------------------------------------
  Adds a text column.
  @param {string} text
  @param {string} tooltip
]]--------------------------------------------------------------------
function PANEL:AddColumn(text, tooltip)
  local label = vgui.Create('DLabel', self)
  label:SetTextColor(self:GetSkin().Colours.Label.Dark)
  label:SetText(text)
  label:SizeToContents()
  label:SetTooltip(tooltip)
  label:SetMouseInputEnabled(true)
  label:Dock(LEFT)
end

--[[------------------------------------------------------------------
  Edits a column's text.
  @param {number} child ID
  @param {string} text
]]--------------------------------------------------------------------
function PANEL:SetColumn(i, text)
  self:GetChild(i):SetText(text)
end

--[[------------------------------------------------------------------
  Evenly distributes children across its length.
]]--------------------------------------------------------------------
function PANEL:PerformLayout(w, h)
  w = w - self.Buttons:GetWide()
  local count = self:ChildCount() - 1
  for i=1, count do
    self:GetChild(i):SetWide(w / count)
  end
end
vgui.Register('HL2HUD_CommandLine', PANEL, 'HL2HUD_ButtonedLine')