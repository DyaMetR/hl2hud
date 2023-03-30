--[[------------------------------------------------------------------
	Boolean parameter with a checkbox.
]]--------------------------------------------------------------------

if SERVER then return end

local PANEL = {}

--[[------------------------------------------------------------------
	Initialize checkbox.
]]--------------------------------------------------------------------
function PANEL:Init()
	local checkbox = vgui.Create('DCheckBox', self)
	checkbox.OnChange = function(_, value) self:OnValueChanged(value) end
	self.CheckBox = checkbox
end

--[[------------------------------------------------------------------
	Moves the checkbox to the side.
]]--------------------------------------------------------------------
function PANEL:OnTitleSizeChanged(wide)
	self.CheckBox:SetPos(wide + 10, 10)
end

--[[------------------------------------------------------------------
	Changes the checked status.
]]--------------------------------------------------------------------
function PANEL:SetValue(value)
	self.CheckBox:SetValue(value)
end

vgui.Register('HL2HUD_BooleanParameter', PANEL, 'HL2HUD_Parameter')
