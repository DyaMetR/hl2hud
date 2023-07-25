--[[------------------------------------------------------------------
	Base for element parameters settings.
]]--------------------------------------------------------------------

if SERVER then return end

local COLOUR_BACKGROUND, COLOUR_TITLE = Color(80, 80, 80), Color(200, 200, 200)

local PANEL = {}

--[[------------------------------------------------------------------
	Creates the title and subtitle upon initialization.
]]--------------------------------------------------------------------
function PANEL:Init()
	self:SetMinimumSize(nil, 34)

	-- create tag
	local title = vgui.Create('DPanel', self)
	title:SetPos(5, 5)
	title.Paint = function() draw.RoundedBox(4, 0, 0, title:GetWide(), title:GetTall(), COLOUR_BACKGROUND) end
	title.OnSizeChanged = function(_, w, h) self:OnTitleSizeChanged(w) end
	self.Title = title

	-- create tag text
	local label = vgui.Create('DLabel', title)
	label:SetTextColor(COLOUR_TITLE)
	label:SetFont('HudHintTextLarge')
	label:SetPos(6, 4)
	title.Label = label

  -- reset button
  local reset = self:AddButton('icon16/arrow_refresh.png')
  reset.DoClick = function() self:OnValueReset() end
  self.Reset = reset
end

--[[------------------------------------------------------------------
	Sets the title of the element parameter.
	@param {string} title
]]--------------------------------------------------------------------
function PANEL:SetTitle(title)
	self.Title.Label:SetText(title)
	self.Title.Label:SizeToContents()
	self.Title:SetWide(self.Title.Label:GetWide() + 14)
  self.Reset:SetTooltip(string.format(language.GetPhrase('hl2hud.menu.hudlayout.parameter.reset'), title))
	self:OnTitleSizeChanged(self.Title:GetWide())
end

--[[------------------------------------------------------------------
	Sets the data source of the element.
	@param {table} source
]]--------------------------------------------------------------------
function PANEL:SetSource(source)
	self.Source = source
end

--[[------------------------------------------------------------------
	Sets the parameter this control is pointing to.
	@param {string} element
	@param {string} parameter
]]--------------------------------------------------------------------
function PANEL:SetParameter(element, parameter)
	self.Element = element
	self.Parameter = parameter
end

--[[------------------------------------------------------------------
	Called when the title's size changes.
	@param {number} width
]]--------------------------------------------------------------------
function PANEL:OnTitleSizeChanged(wide) end

--[[------------------------------------------------------------------
	Transfers the given value to the controls.
	@param {any} value
]]--------------------------------------------------------------------
function PANEL:SetValue(value) end

--[[------------------------------------------------------------------
	Called when the parameter value is supposed to change.
	@param {any} value
]]--------------------------------------------------------------------
function PANEL:OnValueChanged(value) end

--[[------------------------------------------------------------------
	Called when the parameter value is supposed to be reset.
]]--------------------------------------------------------------------
function PANEL:OnValueReset() end

--[[------------------------------------------------------------------
	Override to call OnValueReset instead.
]]--------------------------------------------------------------------
function PANEL:DoClick() self:OnValueReset() end

vgui.Register('HL2HUD_Parameter', PANEL, 'HL2HUD_ButtonedLine')
