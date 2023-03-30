
if SERVER then return end

local PANEL = {}

--[[------------------------------------------------------------------
  Draw a plain background.
]]--------------------------------------------------------------------
function PANEL:Paint()
  local skin = self:GetSkin()
  if self.m_bAlt then
    skin.tex.Input.ListBox.EvenLine(0, 0, self:GetWide(), self:GetTall())
  else
    skin.tex.Input.ListBox.OddLine(0, 0, self:GetWide(), self:GetTall())
  end
end

vgui.Register('HL2HUD_PanelList_Line', PANEL, 'Panel')
