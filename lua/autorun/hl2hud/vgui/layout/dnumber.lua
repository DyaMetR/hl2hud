--[[------------------------------------------------------------------
	Number parameter with no limits.
]]--------------------------------------------------------------------

if SERVER then return end

local HINT_COLOUR = Color(120, 120, 120)

local PANEL = {}

DEFINE_BASECLASS('HL2HUD_Parameter')

--[[------------------------------------------------------------------
	Initialize the adequate setter control.
]]--------------------------------------------------------------------
function PANEL:Init()
	local wang = vgui.Create('DNumberWang', self)
	wang.OnValueChanged = function(_, value) self:OnValueChanged(wang:GetValue()) end
	self.Wang = wang
end

--[[------------------------------------------------------------------
	Adds details about the value limits.
	@param {string} element
	@param {string} parameter
]]--------------------------------------------------------------------
function PANEL:SetParameter(element, parameter)
	BaseClass.SetParameter(self, element, parameter)
	if not istable(parameter) then self.Wang:SetMinMax(-9999, 9999) return end

	-- add a hint of this parameter's limits
	local properties = HL2HUD.element.get(element).parameters[parameter]
	if properties.min or properties.max then
		local label = vgui.Create('DLabel', self)
		label:SetPos(control:GetX() + control:GetWide() + 8, 10)
		label:SetTextColor(HINT_COLOUR)
		if not properties.min then
			label:SetText(string.format(language.GetPhrase('hl2hud.menu.hudlayout.parameter.number.max'), properties.max))
			self.Wang:SetMax(properties.max)
		elseif not properties.max then
			label:SetText(string.format(language.GetPhrase('hl2hud.menu.hudlayout.parameter.number.min'), properties.min))
			self.Wang:SetMin(properties.min)
		else
			label:SetText(string.format(language.GetPhrase('hl2hud.menu.hudlayout.parameter.number.minmax')), properties.min, properties.max)
			self.Wang:SetMinMax(properties.min, properties.max)
		end
		label:SizeToContents()
	else
		self.Wang:SetMinMax(-9999, 9999)
	end
end

--[[------------------------------------------------------------------
	Repositions the number wang.
]]--------------------------------------------------------------------
function PANEL:OnTitleSizeChanged(wide)
	self.Wang:SetPos(wide + 10, 7)
end

--[[------------------------------------------------------------------
	Set the slider's value.
	@param {number} value
]]--------------------------------------------------------------------
function PANEL:SetValue(value)
	self.Wang:SetValue(value)
end

vgui.Register('HL2HUD_NumberParameter', PANEL, 'HL2HUD_Parameter')
