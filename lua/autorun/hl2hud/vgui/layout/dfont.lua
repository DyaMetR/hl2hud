--[[------------------------------------------------------------------
	Registered font selector -- similar to option with different logic.
]]--------------------------------------------------------------------

if SERVER then return end

local PANEL = {}

DEFINE_BASECLASS('HL2HUD_Parameter')

--[[------------------------------------------------------------------
	Initialize combo box.
]]--------------------------------------------------------------------
function PANEL:Init()
	local options = vgui.Create('DComboBox', self)
	options:SetWide(128)
	options.OnSelect = function(_, _, option) self:OnValueChanged(option) end
	self.Options = options
end

--[[------------------------------------------------------------------
	Repositions the options.
]]--------------------------------------------------------------------
function PANEL:OnTitleSizeChanged(wide)
	self.Options:SetPos(wide + 10, 7)
end

--[[------------------------------------------------------------------
	Populates the font list after setting the data source.
]]--------------------------------------------------------------------
function PANEL:SetSource(source)
  BaseClass.SetSource(self, source)
	self:Populate()
end

--[[------------------------------------------------------------------
	Clear and repopulate the combo box with fonts.
]]--------------------------------------------------------------------
function PANEL:Populate()
	self.Options:Clear()
	for holder, font in pairs(self.Source.ClientScheme.Fonts) do
		self.Options:AddChoice(holder, font)
	end
end

--[[------------------------------------------------------------------
	Changes the text on the combo box.
]]--------------------------------------------------------------------
function PANEL:SetValue(value)
	self.Options:SetValue(value)
end

--[[------------------------------------------------------------------
	Called when the font list is updated.
]]--------------------------------------------------------------------
function PANEL:Refresh()
	self:Populate()
	self:SetValue(self.Source.HudLayout[self.Element][self.Parameter])
end

vgui.Register('HL2HUD_FontParameter', PANEL, 'HL2HUD_Parameter')
