--[[------------------------------------------------------------------
	Text parameter.
]]--------------------------------------------------------------------

if SERVER then return end

local PANEL = {}

--[[------------------------------------------------------------------
	Initialize text entry.
]]--------------------------------------------------------------------
function PANEL:Init()
	local entry = vgui.Create('DTextEntry', self)
	entry:SetWide(256)
  entry:SetUpdateOnType(true)
  entry.OnValueChange = function(_, value) self:OnValueChanged(value) end
	self.TextEntry = entry
end

--[[------------------------------------------------------------------
	Moves the text entry to the side.
]]--------------------------------------------------------------------
function PANEL:OnTitleSizeChanged(wide)
	self.TextEntry:SetPos(wide + 10, 7)
end

--[[------------------------------------------------------------------
	Set the text entry's default text.
	@param {string} value
]]--------------------------------------------------------------------
function PANEL:SetValue(value)
	self.TextEntry:SetValue(value)
end

vgui.Register('HL2HUD_StringParameter', PANEL, 'HL2HUD_Parameter')
