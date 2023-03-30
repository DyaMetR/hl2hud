
if SERVER then return end

local PANEL = {}

--[[------------------------------------------------------------------
	Initialize combo box with preview.
]]--------------------------------------------------------------------
function PANEL:OnMenuOpened(menu)
	for i=1, menu:ChildCount() do
		local panel = vgui.Create('DPanel', menu:GetChild(i))
		panel:SetPos(4, 4)
		panel:SetSize(24, 14)
		panel:SetBackgroundColor(self.Colors[menu:GetChild(i):GetText()])
	end
end

--[[------------------------------------------------------------------
	Sets the colour list.
  @param {table} colour table
]]--------------------------------------------------------------------
function PANEL:SetColors(colours)
  self.Colors = colours
  for colour, _ in pairs(self.Colors) do
		self:AddChoice(colour)
	end
end

vgui.Register('DColorComboBox', PANEL, 'DComboBox')
