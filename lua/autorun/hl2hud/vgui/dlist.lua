
if SERVER then return end

local PANEL = {}

Derma_Hook( PANEL, 'Paint', 'Paint', 'ListView' )

--[[------------------------------------------------------------------
  Creates the scroll panel.
]]--------------------------------------------------------------------
function PANEL:Init()
  local scroll = vgui.Create('DScrollPanel', self)
  scroll:Dock(FILL)
  scroll:DockMargin(1, 1, 1, 1)
  self.ScrollPanel = scroll
end

--[[------------------------------------------------------------------
  Adds a panel to the list.
  @param {string} panel class
  @return {HL2HUD_PanelList_Line} created line
  @return {Panel} created panel
]]--------------------------------------------------------------------
function PANEL:AddLine(class)
  local line = vgui.Create('HL2HUD_PanelList_Line', self.ScrollPanel)
  line:Dock(TOP)
  line.m_bAlt = self.ScrollPanel:GetChild(0):ChildCount() % 2 ~= 0

    local panel = vgui.Create(class, line)

  return line, panel
end

--[[------------------------------------------------------------------
  Clears the scroll panel.
]]--------------------------------------------------------------------
function PANEL:Clear()
  self.ScrollPanel:Clear()
end

--[[------------------------------------------------------------------
  Paints the background like a DListView.
]]--------------------------------------------------------------------
--[[function PANEL:Paint()
  local skin = self:GetSkin()
  if not skin.tex.Input.ListBox then return end
  skin.tex.Input.ListBox.Background(0, 0, self:GetWide(), self:GetTall())
end]]

vgui.Register('HL2HUD_PanelList', PANEL, 'DPanel')
