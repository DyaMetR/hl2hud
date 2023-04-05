
if SERVER then return end

local ELEMENT = HL2HUD.elements.Register('HudSuit', 'CHudBattery')

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

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

local m_iSuit = -1
function ELEMENT:Init()
	self:Variable('BgColor', table.Copy(self.colours.BgColor))
	self:Variable('FgColor', table.Copy(self.colours.FgColor))
  self:Variable('Position', Vector(0, 0))
  self:Variable('Size', Vector(0, 0))
  self:Variable('Blur', 0)
	self:Variable('Alpha', 255)
  m_iSuit = -1
end

function ELEMENT:OnThink()
	local suit = LocalPlayer():Armor()
	if suit ~= m_iSuit then
		if suit <= 0 then
			HL2HUD.animations.StartAnimationSequence('SuitPowerZero')
		else
			if suit > m_iSuit then
				HL2HUD.animations.StartAnimationSequence('SuitPowerIncreased')
			else
				HL2HUD.animations.StartAnimationSequence('SuitDamageTaken')
        if suit < 20 then
          HL2HUD.animations.StartAnimationSequence('SuitArmorLow')
        end
			end
		end
		m_iSuit = suit
	end
end

function ELEMENT:Draw(settings, scale)
	local x, y = settings.xpos * scale, settings.ypos * scale
	local w, h = settings.wide * scale, settings.tall * scale
  local align
	if settings.halign > 1 then x = ScrW() - (x + w) end
	if settings.valign > 1 then y = ScrH() - (y + h) end
  if settings.digit_align > 1 then align = TEXT_ALIGN_RIGHT end
  render.SetScissorRect(x, y, x + w, y + h, true)
	surface.SetAlphaMultiplier(self.variables.Alpha / 255)
	draw.RoundedBox(8, x, y, w, h, self.variables.BgColor)
	HL2HUD.utils.DrawGlowingText(self.variables.Blur, math.max(LocalPlayer():Armor(), 0), self.fonts.digit_font, self.fonts.digit_font_glow, x + settings.digit_xpos * scale, y + settings.digit_ypos * scale, self.variables.FgColor, self.variables.FgColor, align)
	draw.SimpleText(language.GetPhrase(settings.text), self.fonts.text_font, x + settings.text_xpos * scale, y + settings.text_ypos * scale, self.variables.FgColor)
	surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end
