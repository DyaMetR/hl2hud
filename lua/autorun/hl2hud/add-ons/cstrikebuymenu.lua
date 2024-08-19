--[[------------------------------------------------------------------
  Support for Goldsrc Counter-Strike Buymenu.
  https://steamcommunity.com/sharedfiles/filedetails/?id=3311934020
]]--------------------------------------------------------------------

if SERVER then return end

local ELEMENT = HL2HUD.elements.Register('HudAccount')

ELEMENT:Boolean('visible')
ELEMENT:Number('xpos')
ELEMENT:Number('ypos')
ELEMENT:Number('wide')
ELEMENT:Number('tall')
ELEMENT:Alignment('halign')
ELEMENT:Alignment('valign')
ELEMENT:Number('digit_xpos')
ELEMENT:Number('digit_ypos')
ELEMENT:Font('digit_font')
ELEMENT:Font('digit_font_glow')
ELEMENT:Alignment('digit_align')
ELEMENT:Number('text_xpos')
ELEMENT:Number('text_ypos')
ELEMENT:Font('text_font')
ELEMENT:String('text')
ELEMENT:Number('digit2_xpos')
ELEMENT:Number('digit2_ypos')
ELEMENT:Font('digit2_font')
ELEMENT:Alignment('digit2_align')
ELEMENT:Number('sign_xpos')
ELEMENT:Number('sign_ypos')
ELEMENT:Font('sign_font')
ELEMENT:String('plus')
ELEMENT:String('minus')

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

local m_iPreviousAccount, m_iPreviousDelta = -1, 0
function ELEMENT:Init()
  self:Variable('BgColor', table.Copy(self.colours.BgColor))
  self:Variable('FgColor', table.Copy(self.colours.FgColor))
  self:Variable('Ammo2Color', table.Copy(self.colours.HudIcon_Blank))
  self:Variable('Position', Vector(0, 0))
  self:Variable('Size', Vector(0, 0))
  self:Variable('Blur', 0)
  self:Variable('Alpha', 255)
  m_iPreviousAccount = -1
  m_iPreviousDelta = 0
end

function ELEMENT:OnThink()
  local account = LocalPlayer():GetNW2Int('cstrike_money', 0)
  if account ~= m_iPreviousAccount then
    if m_iPreviousAccount > -1 then
      if account > m_iPreviousAccount then
        HL2HUD.animations.StartAnimationSequence('AccountMoneyAdded')
      else
        HL2HUD.animations.StartAnimationSequence('AccountMoneyRemoved')
      end
      m_iPreviousDelta = account - m_iPreviousAccount
    end
    m_iPreviousAccount = account
  end
end

function ELEMENT:Draw(settings, scale)
  local x, y = (settings.xpos + self.variables.Position.x) * scale, (settings.ypos + self.variables.Position.y) * scale
	local w, h = (settings.wide + self.variables.Size.x) * scale, (settings.tall + self.variables.Size.y) * scale
  local align, align2
	if settings.halign > 1 then x = ScrW() - (x + w) end
	if settings.valign > 1 then y = ScrH() - (y + h) end
  if settings.digit_align > 1 then align = TEXT_ALIGN_RIGHT end
  if settings.digit2_align > 1 then align2 = TEXT_ALIGN_RIGHT end
  render.SetScissorRect(x, y, x + w, y + h, true)
  surface.SetAlphaMultiplier(self.variables.Alpha / 255)
	draw.RoundedBox(8, x, y, w, h, self.variables.BgColor)
	HL2HUD.utils.DrawGlowingText(self.variables.Blur, m_iPreviousAccount, self.fonts.digit_font, self.fonts.digit_font_glow, x + settings.digit_xpos * scale, y + settings.digit_ypos * scale, self.variables.FgColor, self.variables.FgColor, align)
	draw.SimpleText(language.GetPhrase(settings.text), self.fonts.text_font, x + settings.text_xpos * scale, y + settings.text_ypos * scale, self.variables.FgColor)
	draw.SimpleText(math.abs(m_iPreviousDelta), self.fonts.digit2_font, x + settings.digit2_xpos * scale, y + settings.digit2_ypos * scale, self.variables.Ammo2Color, align2)
  draw.SimpleText(m_iPreviousDelta < 0 and settings.minus or settings.plus, self.fonts.sign_font, x + settings.sign_xpos * scale, y + settings.sign_ypos * scale, self.variables.Ammo2Color)
  surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end

-- [[ Default settings ]] --
local SCHEME_DEFAULT = HL2HUD.scheme.Default()
SCHEME_DEFAULT:Element('HudAccount', {
  visible = true,
  xpos = 16,
  ypos = 64,
  wide = 130,
  tall = 36,
  halign = 2,
  valign = 2,
  digit_xpos = 50,
  digit_ypos = 2,
  digit_font = 'HudNumbers',
  digit_font_glow = 'HudNumbersGlow',
  digit_align = 1,
  text_xpos = 8,
  text_ypos = 20,
  text_font = 'HudHintTextSmall',
  text = 'MONEY',
  digit2_xpos = 18,
  digit2_ypos = 1,
  digit2_font = 'HudNumbersSmall',
  digit2_align = 1,
  sign_xpos = 8,
  sign_ypos = 2,
  sign_font = 'HudHintTextLarge',
  plus = '+',
  minus = '-'
})
SCHEME_DEFAULT:Sequence('AccountMoneyAdded', {
  { 'StopEvent', 'AccountMoneyRemoved', 0 },
  { 'Animate', 'HudAccount', 'BgColor', 'BgColor', 'Linear', 0, 0 },
  { 'Animate', 'HudAccount', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
  { 'Animate', 'HudAccount', 'FgColor', 'FgColor', 'Linear', .3, .75 },
  { 'Animate', 'HudAccount', 'Blur', 3, 'Linear', 0, .1 },
  { 'Animate', 'HudAccount', 'Blur', 0, 'Deaccel', .1, 2 },
  { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Green', 'Linear', 0, 0 },
  { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Blank', 'Accel', 0, 3 }
})
SCHEME_DEFAULT:Sequence('AccountMoneyRemoved', {
  { 'StopEvent', 'AccountMoneyAdded', 0 },
  { 'Animate', 'HudAccount', 'BgColor', 'BgColor', 'Linear', 0, 0 },
  { 'Animate', 'HudAccount', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
  { 'Animate', 'HudAccount', 'FgColor', 'FgColor', 'Linear', .3, .75 },
  { 'Animate', 'HudAccount', 'Blur', 3, 'Linear', 0, .1 },
  { 'Animate', 'HudAccount', 'Blur', 0, 'Deaccel', .1, 2 },
  { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Red', 'Linear', 0, 0 },
  { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Blank', 'Accel', 0, 3 }
})
SCHEME_DEFAULT:Colour('HudIcon_Red', Color(255, 0, 0))
SCHEME_DEFAULT:Colour('HudIcon_Green', Color(0, 255, 0))
SCHEME_DEFAULT:Colour('HudIcon_Blank', Color(0, 0, 0, 0))

-- [[ Black Mesa ]] --
local SCHEME_BLACKMESA = HL2HUD.scheme.Get('Black Mesa')
SCHEME_BLACKMESA.HudLayout.HudAccount = {
  xpos = 24,
  ypos = 45,
  wide = 102,
  tall = 46,
  digit_xpos = 92,
  digit_ypos = 12,
  digit_align = 2,
  text_xpos = 10,
  text_ypos = 20,
  text_font = 'HudNumbersSmall',
  text = '$',
  sign_xpos = 10,
  digit2_xpos = 92,
  digit2_align = 2
}
SCHEME_BLACKMESA.HudAnimations.Init = { { commandType = 'Animate', panel = 'HudAccount', variable = 'Blur', target = .3, interpolator = 'Linear', startTime = 0, duration = 0 } }
SCHEME_BLACKMESA.HudAnimations.AccountMoneyAdded = {
  { commandType = 'StopEvent', param = 'AccountMoneyRemoved', startTime = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'BgColor', target = 'BgColor', interpolator = 'Linear', startTime = 0, duration = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'FgColor', target = 'BrightFg', interpolator = 'Linear', startTime = 0, duration = .25 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'FgColor', target = 'FgColor', interpolator = 'Linear', startTime = .3, duration = .75 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Blur', target = 3, interpolator = 'Linear', startTime = 0, duration = .1 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Blur', target = .3, interpolator = 'Deaccel', startTime = .1, duration = 2 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Ammo2Color', target = 'HudIcon_Green', interpolator = 'Linear', startTime = 0, duration = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Ammo2Color', target = 'HudIcon_Blank', interpolator = 'Accel', startTime = 0, duration = 3 }
}
SCHEME_BLACKMESA.HudAnimations.AccountMoneyRemoved = {
  { commandType = 'StopEvent', param = 'AccountMoneyAdded', startTime = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'BgColor', target = 'BgColor', interpolator = 'Linear', startTime = 0, duration = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'FgColor', target = 'BrightFg', interpolator = 'Linear', startTime = 0, duration = .25 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'FgColor', target = 'FgColor', interpolator = 'Linear', startTime = .3, duration = .75 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Blur', target = 3, interpolator = 'Linear', startTime = 0, duration = .1 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Blur', target = .3, interpolator = 'Deaccel', startTime = .1, duration = 2 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Ammo2Color', target = 'HudIcon_Red', interpolator = 'Linear', startTime = 0, duration = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Ammo2Color', target = 'HudIcon_Blank', interpolator = 'Accel', startTime = 0, duration = 3 }
}

-- [[ Blue Moon ]] --
local SCHEME_BLUEMOON = HL2HUD.scheme.Get('Blue Moon')
SCHEME_BLUEMOON.HudLayout.HudAccount = {
  xpos = 79,
  ypos = 12,
  wide = 92,
  tall = 44,
  digit_xpos = 7,
  digit_ypos = 10,
  text_ypos = 4,
  digit2_xpos = 50,
  digit2_ypos = 0,
  sign_xpos = 45,
  sign_ypos = 0
}

-- [[ Compact ]] --
local SCHEME_COMPACT = HL2HUD.scheme.Get('Compact')
SCHEME_COMPACT.HudLayout.HudAccount = {
  xpos = 17,
  ypos = 61,
  wide = 86,
  tall = 44,
  digit_xpos = 7,
  digit_ypos = 9,
  text_xpos = 7,
  text_ypos = 4
}

-- [[ Counter-Strike ]] --
local SCHEME_CSTRIKE = HL2HUD.scheme.Get('Counter-Strike')
table.insert(SCHEME_CSTRIKE.HudAnimations.Init, { commandType = 'Animate', panel = 'HudAccount', variable = 'BgColor', target = 'Blank', interpolator = 'Linear', startTime = 0, duration = 0 })
SCHEME_CSTRIKE.HudLayout.HudAccount = {
  xpos = 15,
  ypos = 42,
  wide = 108,
  tall = 45,
  digit_xpos = 100,
  digit_ypos = 16,
  digit_align = 2,
  text_xpos = 9,
  text_ypos = 16,
  text_font = 'HudNumbers',
  text = '$',
  digit2_xpos = 100,
  digit2_ypos = -4,
  digit2_align = 2,
  digit2_font = 'HudNumbers',
  sign_xpos = 9,
  sign_ypos = -3,
  sign_font = 'HudNumbers'
}
SCHEME_CSTRIKE.HudAnimations.AccountMoneyAdded = {
  { commandType = 'StopEvent', param = 'AccountMoneyRemoved', startTime = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'FgColor', target = 'HudIcon_Green', interpolator = 'Linear', startTime = 0, duration = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'FgColor', target = 'FgColor', interpolator = 'Accel', startTime = 0, duration = 3 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Ammo2Color', target = 'HudIcon_Green', interpolator = 'Linear', startTime = 0, duration = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Ammo2Color', target = 'HudIcon_Blank', interpolator = 'Accel', startTime = 0, duration = 3 }
}
SCHEME_CSTRIKE.HudAnimations.AccountMoneyRemoved = {
  { commandType = 'StopEvent', param = 'AccountMoneyAdded', startTime = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'FgColor', target = 'HudIcon_Red', interpolator = 'Linear', startTime = 0, duration = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'FgColor', target = 'FgColor', interpolator = 'Accel', startTime = 0, duration = 3 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Ammo2Color', target = 'HudIcon_Red', interpolator = 'Linear', startTime = 0, duration = 0 },
  { commandType = 'Animate', panel = 'HudAccount', variable = 'Ammo2Color', target = 'HudIcon_Blank', interpolator = 'Accel', startTime = 0, duration = 3 }
}