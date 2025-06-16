
if SERVER then return end

local PANEL = {}

local FONTSCALING_ICONS = {
  "icon16/lock.png",
  "icon16/text_smallcaps.png",
  "icon16/text_allcaps.png"
}

--[[------------------------------------------------------------------
  Creates the controls.
]]--------------------------------------------------------------------
function PANEL:Init()
  -- font family
  local font = vgui.Create('DTextEntry', self)
  font:Dock(FILL)
  font:DockMargin(0, 0, 2, 0)
  font:SetPlaceholderText('#hl2hud.menu.clientscheme.fonts.properties.font')
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
  size:SetTooltip('#hl2hud.menu.clientscheme.fonts.properties.size')
  size.OnValueChanged = function(_) self:OnValueChanged() end
  self.Size = size

  -- bold
  local bold = vgui.Create('DButton', controls)
  bold:SetX(34)
  bold:SetSize(24, 20)
  bold:SetImage('icon16/text_bold.png')
  bold:SetIsToggle(true)
  bold:SetTooltip('#hl2hud.menu.clientscheme.fonts.properties.weight_bold')
  bold:SetText('')
  bold.OnToggled = function(_) self:OnValueChanged() end
  self.Weight = bold

  -- additive
  local additive = vgui.Create('DButton', controls)
  additive:SetX(60)
  additive:SetSize(24, 20)
  additive:SetImage('icon16/rainbow.png')
  additive:SetIsToggle(true)
  additive:SetTooltip('#hl2hud.menu.clientscheme.fonts.properties.additive')
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
  blur:SetTooltip('#hl2hud.menu.clientscheme.fonts.properties.blur')
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
  scanlines:SetTooltip('#hl2hud.menu.clientscheme.fonts.properties.scanlines')
  scanlines.OnValueChanged = function(_) self:OnValueChanged() end
  self.Scanlines = scanlines

  -- symbol
  local symbol = vgui.Create('DButton', controls)
  symbol:SetX(197)
  symbol:SetSize(24, 20)
  symbol:SetImage('icon16/emoticon_grin.png')
  symbol:SetIsToggle(true)
  symbol:SetTooltip('#hl2hud.menu.clientscheme.fonts.properties.symbol')
  symbol:SetText('')
  symbol.OnToggled = function(_) self:OnValueChanged() end
  self.Symbol = symbol

  -- scaling
  local scaling = vgui.Create('DButton', controls)
  scaling:SetX(223)
  scaling:SetSize(24, 20)
  scaling:SetImage('icon16/text_smallcaps.png')
  scaling:SetTooltip('#hl2hud.menu.clientscheme.fonts.properties.scaling')
  scaling:SetText('')
  scaling.GetValue = function(self) return self.Value end
  scaling.SetValue = function(self, value)
    if isbool(value) then value = value and HL2HUD.FONTSCALING_UNLIMITED or HL2HUD.FONTSCALING_NONE end -- retro-compatibility with pre 1.10
    value = math.Clamp(value or HL2HUD.FONTSCALING_UNLIMITED, HL2HUD.FONTSCALING_NONE, HL2HUD.FONTSCALING_UNLIMITED)
    scaling:SetIcon(FONTSCALING_ICONS[value + 1])
    self.Value = value
  end
  scaling.DoClick = function()
    local menu = DermaMenu()
    for i=HL2HUD.FONTSCALING_NONE, HL2HUD.FONTSCALING_UNLIMITED do
      menu:AddOption('#hl2hud.menu.clientscheme.fonts.properties.scaling' .. i, function()
        scaling:SetValue(i)
        self:OnValueChanged()
      end):SetIcon(FONTSCALING_ICONS[i + 1])
    end
    menu:Open()
  end
  scaling:SetValue(HL2HUD.FONTSCALING_UNLIMITED)
  self.Scaling = scaling

  -- scalable
  local antialias = vgui.Create('DButton', controls)
  antialias:SetX(249)
  antialias:SetSize(24, 20)
  antialias:SetImage('icon16/script_palette.png')
  antialias:SetIsToggle(true)
  antialias:SetTooltip('#hl2hud.menu.clientscheme.fonts.properties.antialias')
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
  @param {HL2HUD.FONTSCALING} scaling
  @param {boolean} antialias
]]--------------------------------------------------------------------
function PANEL:SetFont(font, size, weight, additive, blur, scanlines, symbol, scaling, antialias)
  local bold = false
  if weight then bold = weight >= 1000 end
  self.Font:SetText(font)
  self.Size:SetText(size or 0)
  self.Weight:SetToggle(bold)
  self.Additive:SetToggle(additive)
  self.Blur:SetText(blur or 0)
  self.Scanlines:SetText(scanlines or 0)
  self.Symbol:SetToggle(symbol)
  self.Scaling:SetValue(scaling)
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
    scaling = self.Scaling:GetValue(),
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
  self.Scaling:SetValue(HL2HUD.FONTSCALING_UNLIMITED)
end

vgui.Register('HL2HUD_FontEditor', PANEL, 'Panel')
