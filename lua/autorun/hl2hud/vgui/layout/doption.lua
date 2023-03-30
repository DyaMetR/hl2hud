--[[------------------------------------------------------------------
	Number parameter with a fix set of options to choose from.
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
	options.OnSelect = function(_, option) self:OnValueChanged(option) end
	self.Options = options
end

--[[------------------------------------------------------------------
	Repositions the options.
]]--------------------------------------------------------------------
function PANEL:OnTitleSizeChanged(wide)
	self.Options:SetPos(wide + 10, 7)
end

--[[------------------------------------------------------------------
	Populates the combo box.
	@param {string} element
	@param {string} parameter
]]--------------------------------------------------------------------
function PANEL:SetParameter(element, parameter)
	BaseClass.SetParameter(self, element, parameter)
	for _, option in pairs(HL2HUD.elements.Get(element).parameters[parameter].options) do
		self.Options:AddChoice(option)
	end
end

--[[------------------------------------------------------------------
	Pre-select option.
]]--------------------------------------------------------------------
function PANEL:SetValue(value)
	self.Options:ChooseOptionID(value)
end

vgui.Register('HL2HUD_OptionParameter', PANEL, 'HL2HUD_Parameter')
