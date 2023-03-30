--[[------------------------------------------------------------------
	Colour parameter with a preview.
]]--------------------------------------------------------------------

if SERVER then return end

local PANEL = {}

DEFINE_BASECLASS('HL2HUD_Parameter')

--[[------------------------------------------------------------------
	Initialize combo box with preview.
]]--------------------------------------------------------------------
function PANEL:Init()
	local preview

	-- create options
	local options = vgui.Create('DComboBox', self)
	options:SetWide(128)
	options.OnSelect = function(_, _, option)
		self:OnValueChanged(option)
		preview:SetBackgroundColor(self.Source.ClientScheme.Colors[option])
	end
	options.OnMenuOpened = function(_, menu)
		for i=1, menu:ChildCount() do
			local panel = vgui.Create('DPanel', menu:GetChild(i))
			panel:SetPos(4, 4)
			panel:SetSize(24, 14)
			panel:SetBackgroundColor(self.Source.ClientScheme.Colors[menu:GetChild(i):GetText()])
		end
	end
	self.Options = options

	-- create preview
	preview = vgui.Create('DPanel', self)
	self.Preview = preview
end

--[[------------------------------------------------------------------
	Reposition subcontrols.
]]--------------------------------------------------------------------
function PANEL:OnTitleSizeChanged(wide)
	self.Preview:SetPos(wide + 10, 5)
	self.Options:SetPos(wide + self.Preview:GetWide() + 15, 7)
end

--[[------------------------------------------------------------------
	Clear and repopulate the combo box with colours.
]]--------------------------------------------------------------------
function PANEL:Populate()
	self.Options:Clear()
	for colour, value in pairs(self.Source.ClientScheme.Colors) do
		self.Options:AddChoice(colour, value)
	end
end

--[[------------------------------------------------------------------
	Populates the colour list after setting the data source.
]]--------------------------------------------------------------------
function PANEL:SetSource(source)
  BaseClass.SetSource(self, source)
	self:Populate()
end

--[[------------------------------------------------------------------
	Changes the preview colour and the selected colour's name.
]]--------------------------------------------------------------------
function PANEL:SetValue(value)
	self.Options:SetValue(value)
	self.Preview:SetBackgroundColor(self.Source.ClientScheme.Colors[value])
end

--[[------------------------------------------------------------------
	Called when the colour list is updated.
]]--------------------------------------------------------------------
function PANEL:Refresh()
	self:Populate()
	self:SetValue(self.Source.HudLayout[self.Element][self.Parameter])
end

--[[------------------------------------------------------------------
	Updates the preview to always reflect the colour.
]]--------------------------------------------------------------------
function PANEL:Think()
	self.Preview:SetBackgroundColor(self.Source.ClientScheme.Colors[self.Source.HudLayout[self.Element][self.Parameter]])
end

vgui.Register('HL2HUD_ColourParameter', PANEL, 'HL2HUD_Parameter')
