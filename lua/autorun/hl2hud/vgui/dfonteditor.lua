
if SERVER then return end

local PANEL = {}

local LOCALE_FONT       = 'Font family'
local LOCALE_SIZE       = 'Font size'
local LOCALE_WEIGHT     = 'Bold'
local LOCALE_ADDITIVE   = 'Additive'
local LOCALE_BLUR       = 'Blur size'
local LOCALE_SCANLINES  = 'Scanlines'
local LOCALE_SYMBOL     = 'Enable symbols'
local LOCALE_SCALABLE   = 'Scalable'
local LOCALE_ANTIALIAS  = 'Antialias'

--[[------------------------------------------------------------------
	Creates the controls.
]]--------------------------------------------------------------------
function PANEL:Init()
	-- font family
	local font = vgui.Create('DTextEntry', self)
  font:Dock(FILL)
  font:DockMargin(0, 0, 2, 0)
	font:SetPlaceholderText(LOCALE_FONT)
	font.OnLoseFocus = function(_) self:OnValueChanged() end
	self.Font = font

  -- fix sized controls
  local controls = vgui.Create('Panel', self)
  controls:SetX(32)
  controls:SetWide(273)
  controls:Dock(RIGHT)
  self.Controls = controls

	-- font size
	local size = vgui.Create('DNumberWang', controls)
	size:SetWide(32)
	size:SetTooltip(LOCALE_SIZE)
	size.OnValueChanged = function(_) self:OnValueChanged() end
	self.Size = size

	-- bold
	local bold = vgui.Create('DButton', controls)
	bold:SetX(34)
	bold:SetSize(24, 20)
	bold:SetImage('icon16/text_bold.png')
	bold:SetIsToggle(true)
	bold:SetTooltip(LOCALE_WEIGHT)
	bold:SetText('')
	bold.OnToggled = function(_) self:OnValueChanged() end
	self.Weight = bold

	-- additive
	local additive = vgui.Create('DButton', controls)
	additive:SetX(60)
	additive:SetSize(24, 20)
	additive:SetImage('icon16/rainbow.png')
	additive:SetIsToggle(true)
	additive:SetTooltip(LOCALE_ADDITIVE)
	additive:SetText('')
	additive.OnToggled = function(_) self:OnValueChanged() end
	self.Additive = additive

	-- blur size icon
  local icon = vgui.Create('DImage', controls)
  icon:SetPos(88, 2)
  icon:SetSize(16, 16)
  icon:SetImage('icon16/shading.png')

	-- blur size
	local blur = vgui.Create('DNumberWang', controls)
	blur:SetX(108)
	blur:SetWide(32)
  blur:SetTooltip(LOCALE_BLUR)
	blur.OnValueChanged = function(_) self:OnValueChanged() end
	self.Blur = blur

	-- scanlines icon
  local icon = vgui.Create('DImage', controls)
  icon:SetPos(143, 2)
  icon:SetSize(16, 16)
  icon:SetImage('icon16/text_align_center.png')

	-- scanlines
	local scanlines = vgui.Create('DNumberWang', controls)
	scanlines:SetX(163)
	scanlines:SetWide(32)
  scanlines:SetTooltip(LOCALE_SCANLINES)
	scanlines.OnValueChanged = function(_) self:OnValueChanged() end
	self.Scanlines = scanlines

  -- symbol
	local symbol = vgui.Create('DButton', controls)
	symbol:SetX(197)
	symbol:SetSize(24, 20)
	symbol:SetImage('icon16/emoticon_grin.png')
	symbol:SetIsToggle(true)
	symbol:SetTooltip(LOCALE_SYMBOL)
	symbol:SetText('')
	symbol.OnToggled = function(_) self:OnValueChanged() end
	self.Symbol = symbol

  -- scalable
  local scalable = vgui.Create('DButton', controls)
  scalable:SetX(223)
  scalable:SetSize(24, 20)
  scalable:SetImage('icon16/text_smallcaps.png')
  scalable:SetIsToggle(true)
  scalable:SetTooltip(LOCALE_SCALABLE)
  scalable:SetText('')
  scalable:SetToggle(true)
  scalable.OnToggled = function(_) self:OnValueChanged() end
  self.Scalable = scalable

  -- scalable
  local antialias = vgui.Create('DButton', controls)
  antialias:SetX(249)
  antialias:SetSize(24, 20)
  antialias:SetImage('icon16/script_palette.png')
  antialias:SetIsToggle(true)
  antialias:SetTooltip(LOCALE_ANTIALIAS)
  antialias:SetText('')
  antialias:SetToggle(true)
  antialias.OnToggled = function(_) self:OnValueChanged() end
  self.Antialias = antialias
end

--[[------------------------------------------------------------------
	Sets the values of the different controls.
	@param {string} font family
	@param {number} size
	@param {number} weight
	@param {boolean} additive
	@param {number} blur size
	@param {number} scanlines
  @param {boolean} is symbolic font
  @param {boolean} scalable
  @param {boolean} antialias
]]--------------------------------------------------------------------
function PANEL:SetFont(font, size, weight, additive, blur, scanlines, symbol, scalable, antialias)
	self.Font:SetText(font)
	self.Size:SetText(size)
	self.Weight:SetToggle(weight >= 1000)
	self.Additive:SetToggle(additive)
	self.Blur:SetText(blur or 0)
	self.Scanlines:SetText(scanlines or 0)
  self.Symbol:SetToggle(symbol)
  self.Scalable:SetToggle(scalable)
  self.Antialias:SetToggle(antialias)
end

--[[------------------------------------------------------------------
	Called when any of the controls have their values changed.
]]--------------------------------------------------------------------
function PANEL:OnValueChanged() end

--[[------------------------------------------------------------------
	Returns the font data produced by the controls' settings.
	@return {table} font data
]]--------------------------------------------------------------------
function PANEL:GenerateFontData()
	local weight = 0
	if self.Weight:GetToggle() then weight = 1000 end
	return {
    font = self.Font:GetValue(),
    size = self.Size:GetValue(),
    weight = weight,
    additive = self.Additive:GetToggle(),
    symbol = self.Symbol:GetToggle(),
    blur = self.Blur:GetValue(),
    scanlines = self.Scanlines:GetValue(),
    scalable = self.Scalable:GetToggle(),
    antialias = self.Antialias:GetToggle()
  }
end

--[[------------------------------------------------------------------
	Resets all controls to default value.
]]--------------------------------------------------------------------
function PANEL:Clear()
	self.Font:SetText('')
	self.Size:SetText(0)
	self.Weight:SetToggle(false)
	self.Additive:SetToggle(false)
	self.Blur:SetText(0)
	self.Scanlines:SetText(0)
  self.Symbol:SetToggle(false)
  self.Scalable:SetToggle(true)
end

vgui.Register('HL2HUD_FontEditor', PANEL, 'Panel')
