
if SERVER then return end

local HOOK_SHOW       = 'HL2HUD_ShouldDrawFlashlight'
local HOOK_FLASHLIGHT = 'HL2HUD_GetFlashlight'

local ELEMENT = HL2HUD.elements.Register('HudFlashlight', 'CHudFlashlight')

ELEMENT:Boolean('visible')
ELEMENT:Number('xpos')
ELEMENT:Number('ypos')
ELEMENT:Number('wide')
ELEMENT:Number('tall')
ELEMENT:Alignment('halign')
ELEMENT:Alignment('valign')
ELEMENT:Font('font')
ELEMENT:Number('icon_xpos')
ELEMENT:Number('icon_ypos')
ELEMENT:Number('BarInsetX')
ELEMENT:Number('BarInsetY')
ELEMENT:Number('BarWidth')
ELEMENT:Number('BarHeight')
ELEMENT:Number('BarChunkWidth')
ELEMENT:Number('BarChunkGap')
ELEMENT:Colour('NormalColor')
ELEMENT:Colour('CautionColor')

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

local EPISODIC
local m_flFlashBattery
function ELEMENT:OnThink()
  EPISODIC = hook.Run(HOOK_SHOW)
  m_flFlashBattery = hook.Run(HOOK_FLASHLIGHT) or 1
end

function ELEMENT:Draw(settings, scale)
  if not EPISODIC then return end
  local x, y = settings.xpos * scale, settings.ypos * scale
  local w, h = settings.wide * scale, settings.tall * scale
  local barw, barh, chk, gap = settings.BarWidth * scale, settings.BarHeight * scale, settings.BarChunkWidth * scale, settings.BarChunkGap * scale
  if settings.halign > 1 then x = ScrW() - (x + w) end
  if settings.valign > 1 then y = ScrH() - (y + h) end
  local chunks = barw / (chk + gap)
  local enabled = chunks * m_flFlashBattery + .5

  -- is flashlight on
  local alpha, icon = 32, settings.icon_off
  if LocalPlayer():FlashlightIsOn() then
    alpha = 255
    icon = settings.icon_on
  end

  -- select colour
  local colour = self.colours[settings.NormalColor]
  if enabled < chunks * .25 then colour = self.colours[settings.CautionColor] end

  -- draw
  render.SetScissorRect(x, y, x + w, y + h, true)
  draw.RoundedBox(6, x, y, w, h, self.colours.BgColor)
  surface.SetAlphaMultiplier(alpha / 255)
  draw.SimpleText(icon, self.fonts.font, x + settings.icon_xpos * scale, y + settings.icon_ypos * scale, colour)
  if m_flFlashBattery < 1 then
    local inX, inY = settings.BarInsetX * scale, settings.BarInsetY * scale
    for i=1, chunks do
      if i > enabled then surface.SetAlphaMultiplier(alpha / 8 / 255) end
      draw.RoundedBox(0, x + inX + math.ceil(chk + gap) * (i - 1), y + inY, chk, barh, colour)
    end
  end
  surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end
