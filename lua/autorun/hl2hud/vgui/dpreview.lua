
if SERVER then return end

local PANEL = {}

local FRAME_WIDTH = 2
local WEAPON_NAME = 'WEAPON'
local SAMPLE_TEXT = 'SAMPLE TEXT'

local FONT_PREFIX = 'hl2hud_preview_'
local FONT_HUDNUMBERS = 'HudNumbers'
local FONT_HUDNUMBERSGLOW = 'HudNumbersGlow'
local FONT_HUDNUMBERSSMALL = 'HudNumbersSmall'
local FONT_HUDHINTTEXTSMALL = 'HudHintTextSmall'
local FONT_HUDSELECTIONNUMBERS = 'HudSelectionNumbers'
local FONT_HUDSELECTIONTEXT = 'HudSelectionText'
local FONT_WEAPONICON = FONT_PREFIX .. 'WeaponIcon'
local FONT_WEAPONICONGLOW = FONT_PREFIX .. 'WeaponIconGlow'

--[[------------------------------------------------------------------
  Draws a rounded box with two numbers inside.
  @param {number} x
  @param {number} y
  @param {Color} foreground colour
  @param {Color} background colour
  @param {number} HudNumbers number
  @param {number} HudNumbersSmall number
  @param {number} glowing amount
]]--------------------------------------------------------------------
local function DrawNumericDisplay(x, y, num1, num2, fgcol, bgcol, glow)
  local scale = HL2HUD.Scale()
  local w, h = 125 * scale, 40 * scale
  x = x - w * .5
  y = y - h
  draw.RoundedBox(8, x, y, w, h, bgcol)
  x = x + w * .5
  y = y + h * .5
  HL2HUD.utils.DrawGlowingText(glow or 0, num1, FONT_PREFIX .. FONT_HUDNUMBERS, FONT_PREFIX .. FONT_HUDNUMBERSGLOW, x - 2 * scale, y - scale, fgcol, fgcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
  draw.SimpleText(num2, FONT_PREFIX .. FONT_HUDNUMBERSSMALL, x + 2 * scale, y - scale, fgcol, nil, TEXT_ALIGN_CENTER)
end

--[[------------------------------------------------------------------
  Draws a weapon selector.
  @param {number} x
  @param {number} y
  @param {number} slot opened
  @param {string} weapon icon
  @param {Color} numbers colour
  @param {Color} text colour
  @param {Color} weapon icon colour
  @param {Color} background colour
  @param {Color} selected background colour
  @param {Color} empty slot background colour
]]--------------------------------------------------------------------
local function DrawWeaponSelector(x, y, slot, weapon, numcol, textcol, fgcol, bgcol, selbgcol, emptycol)
  local scale = HL2HUD.Scale()
  for i=1, 6 do
    local w, h = 32 * scale, 32 * scale
    local background = bgcol
    if i >= 6 then background = emptycol end
    if i == slot then
      w = 112 * scale
      h = 80 * scale
      background = selbgcol
    end
    draw.RoundedBox(8, x, y, w, h, background)
    if i < 6 then draw.SimpleText(i, FONT_PREFIX .. FONT_HUDSELECTIONNUMBERS, x + 4 * scale, y + 4 * scale, numcol) end
    if i == slot then
      draw.SimpleText(weapon, FONT_WEAPONICON, x + w * .5, y + h * .5, fgcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      draw.SimpleText(weapon, FONT_WEAPONICONGLOW, x + w * .5, y + h * .5, fgcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      draw.SimpleText(WEAPON_NAME, FONT_PREFIX .. FONT_HUDSELECTIONTEXT, x + w * .5, y + 69 * scale, textcol, TEXT_ALIGN_CENTER, nil)
    end
    x = x + w + 8 * scale
  end
end

--[[------------------------------------------------------------------
  Draws a text box.
  @param {number} x
  @param {number} y
  @param {Color} foreground
  @param {Color} background
  @return {number} height
]]--------------------------------------------------------------------
local function DrawTextBox(x, y, fgcol, bgcol)
  surface.SetFont(FONT_PREFIX .. FONT_HUDHINTTEXTSMALL)
  local w, h = surface.GetTextSize(SAMPLE_TEXT)
  w = w * 1.25
  h = h * 2
  draw.RoundedBox(8, x - w * .5, y, w, h, bgcol)
  draw.SimpleText(SAMPLE_TEXT, FONT_PREFIX .. FONT_HUDHINTTEXTSMALL, x, y + h * .5, fgcol, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  return h
end

--[[------------------------------------------------------------------
  Set default parameters.
]]--------------------------------------------------------------------
function PANEL:Init()
  self:SetKeepAspect(true)
end

--[[------------------------------------------------------------------
  Creates a preview font.
  @param {string} font
]]--------------------------------------------------------------------
function PANEL:CreateFontPreview(font)
  local scale = HL2HUD.Scale()
  local data = self.Scheme.ClientScheme.Fonts[font]
  if not data.scalable then scale = 1 end
  surface.CreateFont(FONT_PREFIX .. font, {
    font = data.font,
    size = data.size * scale,
    weight = data.weight,
    additive = data.additive,
    blursize = (data.blur or 0) * scale,
    scanlines = (data.scanlines or 0) * scale
  })
end

--[[------------------------------------------------------------------
  Creates all font previews.
]]--------------------------------------------------------------------
function PANEL:ReloadFonts()
  self:CreateFontPreview(FONT_HUDNUMBERS)
  self:CreateFontPreview(FONT_HUDNUMBERSGLOW)
  self:CreateFontPreview(FONT_HUDNUMBERSSMALL)
  self:CreateFontPreview(FONT_HUDHINTTEXTSMALL)
  self:CreateFontPreview(FONT_HUDSELECTIONNUMBERS)
  self:CreateFontPreview(FONT_HUDSELECTIONTEXT)

  -- create weapon icon fonts
  local size, scale = 56, HL2HUD.Scale()

  surface.CreateFont(FONT_WEAPONICON, {
    font = 'HalfLife2',
    size = size * HL2HUD.Scale(),
    weight = 0,
    additive = self.Scheme.ClientScheme.Fonts.WeaponIcons.additive
  })

  surface.CreateFont(FONT_WEAPONICONGLOW, {
    font = 'HalfLife2',
    size = size * HL2HUD.Scale(),
    weight = 0,
    additive = self.Scheme.ClientScheme.Fonts.WeaponIconsSelected.additive,
    blursize = 5 * scale,
    scanlines = 2 * scale
  })
end

--[[------------------------------------------------------------------
  Paints the actual preview.
]]--------------------------------------------------------------------
function PANEL:PaintOver()
  if not self.Scheme then return end

  local skin = self:GetSkin()
  local scale = HL2HUD.Scale()

  -- draw borders
  draw.RoundedBox(0, 0, 0, self:GetWide(), FRAME_WIDTH, skin.control_color_dark)
  draw.RoundedBox(0, 0, FRAME_WIDTH, FRAME_WIDTH, self:GetTall() - FRAME_WIDTH, skin.control_color_dark)
  draw.RoundedBox(0, self:GetWide() - FRAME_WIDTH, FRAME_WIDTH, FRAME_WIDTH, self:GetTall() - FRAME_WIDTH, skin.control_color_highlight)
  draw.RoundedBox(0, FRAME_WIDTH, self:GetTall() - FRAME_WIDTH, self:GetWide() - FRAME_WIDTH * 2, FRAME_WIDTH, skin.control_color_highlight)

  -- draw weapon selector
  DrawWeaponSelector(4 * scale, 4 * scale, 3, 'a', self.Scheme.ClientScheme.Colors.SelectionNumberFg, self.Scheme.ClientScheme.Colors.SelectionTextFg, self.Scheme.ClientScheme.Colors.BrightFg, self.Scheme.ClientScheme.Colors.SelectionBoxBg, self.Scheme.ClientScheme.Colors.SelectionSelectedBoxBg, self.Scheme.ClientScheme.Colors.SelectionEmptyBoxBg)

  -- draw numeric displays
  DrawNumericDisplay(self:GetWide() * .16, self:GetTall() - 4 * scale, 100, 225, self.Scheme.ClientScheme.Colors.FgColor, self.Scheme.ClientScheme.Colors.BgColor)
  DrawNumericDisplay(self:GetWide() * .5, self:GetTall() - 4 * scale, 76, 128, self.Scheme.ClientScheme.Colors.BrightFg, self.Scheme.ClientScheme.Colors.BgColor, 3)
  DrawNumericDisplay(self:GetWide() * .84, self:GetTall() - 4 * scale, 0, 39, self.Scheme.ClientScheme.Colors.DamagedFg, self.Scheme.ClientScheme.Colors.BgColor)

  -- draw text boxes
  local h = DrawTextBox(self:GetWide() * .9, 4 * scale, self.Scheme.ClientScheme.Colors.FgColor, self.Scheme.ClientScheme.Colors.BgColor)
  DrawTextBox(self:GetWide() * .8, h + 8 * scale, self.Scheme.ClientScheme.Colors.BrightFg, self.Scheme.ClientScheme.Colors.BrightBg)
  DrawTextBox(self:GetWide() * .7, h * 2 + 12 * scale, self.Scheme.ClientScheme.Colors.BrightDamagedFg, self.Scheme.ClientScheme.Colors.BrightDamagedBg)
end

--[[------------------------------------------------------------------
  Stores the reference of the scheme to showcase.
  @param {table} scheme
]]--------------------------------------------------------------------
function PANEL:SetScheme(scheme)
  self.Scheme = scheme
  self:ReloadFonts()
end

vgui.Register('HL2HUD_Preview', PANEL, 'DImage')
