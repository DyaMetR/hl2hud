
if SERVER then return end

local HOOK_MONEY  = 'HL2HUD_GetAccountMoney'

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
ELEMENT:Number('text2_xpos')
ELEMENT:Number('text2_ypos')
ELEMENT:Font('text2_font')
ELEMENT:String('plus')
ELEMENT:String('minus')

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

local m_iPreviousAccount, m_iPreviousDelta
function ELEMENT:Init()
  self:Variable('BgColor', table.Copy(self.colours.BgColor))
  self:Variable('FgColor', table.Copy(self.colours.FgColor))
  self:Variable('Ammo2Color', table.Copy(self.colours.Blank))
  self:Variable('Position', Vector(0, 0))
  self:Variable('Size', Vector(0, 0))
  self:Variable('Blur', 0)
  self:Variable('Alpha', 255)
end

function ELEMENT:OnThink()
  local account = hook.Run(HOOK_MONEY)
  if not account then m_iPreviousAccount = nil return end
  if not m_iPreviousAccount then
    m_iPreviousAccount = account
    m_iPreviousDelta = 0
  else
    if m_iPreviousAccount ~= account then
        HL2HUD.animations.StartAnimationSequence(account > m_iPreviousAccount and 'AccountMoneyAdded' or 'AccountMoneyRemoved')
        m_iPreviousDelta = account - m_iPreviousAccount
        m_iPreviousAccount = account
    end
  end
end

function ELEMENT:Draw(settings, scale)
  if not m_iPreviousAccount then return end
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
  draw.SimpleText(language.GetPhrase(m_iPreviousDelta < 0 and settings.minus or settings.plus), self.fonts.text2_font, x + settings.text2_xpos * scale, y + settings.text2_ypos * scale, self.variables.Ammo2Color)
  surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end