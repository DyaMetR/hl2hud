
if SERVER then return end

local ZOOM_MATERIAL = surface.GetTextureID('vgui/zoom')
local ZOOM_FADE_TIME = .4

local ELEMENT = HL2HUD.elements.Register('HudZoom', 'CHudZoom')

ELEMENT:Boolean('visible')
ELEMENT:Number('Circle1Radius')
ELEMENT:Number('Circle2Radius')
ELEMENT:Number('DashGap')
ELEMENT:Number('DashHeight')
ELEMENT:Colour('Color')

local m_bZoomOn, m_flZoomStartTime = false, -1
function ELEMENT:OnThink()
  local zoom = LocalPlayer():KeyDown(IN_ZOOM)
  if m_bZoomOn ~= zoom then
    m_flZoomStartTime = CurTime()
    m_bZoomOn = zoom
  end
end

function ELEMENT:Draw(settings, scale)
  local x, y = ScrW() * .5, ScrH() * .5
  local colour = self.colours[settings.Color]

  local delta = CurTime() - m_flZoomStartTime
  local progress = math.Clamp(delta / ZOOM_FADE_TIME, 0, 1)
  local alpha

  if m_bZoomOn then
    alpha = progress
  else
    if progress >= 1 then return end
    alpha = (1 - progress) * .25
    progress = 1 - (progress * .5)
  end

  surface.SetAlphaMultiplier((64 * alpha) / 255)

  -- draw circles
  local r, g, b = colour.r, colour.g, colour.b
  surface.DrawCircle(x, y, settings.Circle1Radius * scale * progress, r, g, b)
  surface.DrawCircle(x, y, settings.Circle2Radius * scale * progress, r, g, b)

  -- draw dashed lines
  local dashCount = 2
  local ypos = y - settings.DashHeight * scale * .5
  local gap = settings.DashGap * math.max(progress, .1) * scale
  local dashMax = math.max(x, ScrW() - x) / gap
  while dashCount < dashMax do
    local xpos = x - gap * dashCount + .5
    draw.RoundedBox(0, xpos, ypos, 1, settings.DashHeight * scale, colour)
    xpos = x + gap * dashCount + .5
    draw.RoundedBox(0, xpos, ypos, 1, settings.DashHeight * scale, colour)
    dashCount = dashCount + 1
  end

  surface.SetAlphaMultiplier(alpha)

  -- draw vignette
  local w, h = math.ceil(ScrW() / 2), math.ceil(ScrH() / 2)
  surface.SetTexture(ZOOM_MATERIAL)
  surface.SetDrawColor(color_white)
  surface.DrawTexturedRectUV(w, 0, w, h, 0, 0, 1, 1)
  surface.DrawTexturedRectUV(0, 0, w, h, 1, 0, 0, 1)
  surface.DrawTexturedRectUV(0, h, w, h, 1, 1, 0, 0)
  surface.DrawTexturedRectUV(w, h, w, h, 0, 1, 1, 0)

  surface.SetAlphaMultiplier(1)
end
