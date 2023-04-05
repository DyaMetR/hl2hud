
if SERVER then return end

local WARNING_THRESHOLD = .25
local EVENT_DURATION = 1
local BRIGHTNESS_FULL = 255
local BRIGHTNESS_DIM = 64
local FADE_IN_TIME = .5
local FADE_OUT_TIME = 2
local ZOOM_FADE_OUT = .25

local ELEMENT = HL2HUD.elements.Register('HUDQuickInfo', 'CHUDQuickInfo')

ELEMENT:Boolean('visible')
ELEMENT:Number('xpos')
ELEMENT:Number('ypos')
ELEMENT:Font('font')
ELEMENT:String('left_bracket')
ELEMENT:String('left_bracket_empty')
ELEMENT:String('right_bracket')
ELEMENT:String('right_bracket_empty')
ELEMENT:Colour('left_color')
ELEMENT:Colour('right_color')
ELEMENT:Colour('warning_color')
ELEMENT:String('warning_sound')

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

local m_ammoColour, m_healthColour = Color(255, 255, 255), Color(255, 255, 255)
local m_warnColour = Color(255, 255, 255)
function ELEMENT:Init(settings)
  local scalar = 138 / 255
  m_ammoColour = table.Copy(self.colours[settings.right_color])
  m_healthColour = table.Copy(self.colours[settings.left_color])
  m_warnColour = table.Copy(self.colours[settings.warning_color])
  m_ammoColour.a = m_ammoColour.a * scalar
  m_healthColour.a = m_healthColour.a * scalar
end

local m_flAlpha, m_flDim = 1, 0
local m_lastAmmo, m_lastHealth = 1, 1
local m_ammo, m_health = 1, 1
local m_ammoFade, m_healthFade = 0, 0
local m_warnAmmo, m_warnHealth = false, false
local m_flLastEventTime = 0
function ELEMENT:OnThink(settings)
  -- fade out if zooming in
  if LocalPlayer():KeyDown(IN_ZOOM) then
    m_flAlpha = math.max(m_flAlpha - RealFrameTime() / ZOOM_FADE_OUT, 0)
  else
    m_flAlpha = math.min(m_flAlpha + RealFrameTime() / FADE_IN_TIME, 1)
  end

  -- warning blinking
  m_warnColour.a = 138 + math.abs(math.sin(CurTime() * 8) * 128)

  -- health percentage
  local health = math.Clamp(LocalPlayer():Health() / LocalPlayer():GetMaxHealth(), 0, 1)
  if m_healthFade < CurTime() then
    m_health = health
  else
    m_health = 1
  end

  -- ammunition percentage
  local ammo = 1
  local weapon = LocalPlayer():GetActiveWeapon()
  if IsValid(weapon) and weapon:GetPrimaryAmmoType() > 0 then
    if weapon:Clip1() > -1 then
      ammo = weapon:Clip1() / weapon:GetMaxClip1()
    else
      ammo = LocalPlayer():GetAmmoCount(weapon:GetPrimaryAmmoType()) / game.GetAmmoMax(weapon:GetPrimaryAmmoType())
    end
  end
  if m_ammoFade < CurTime() then
    m_ammo = ammo
  else
    m_ammo = 1
  end

  -- trigger highlight animation
  if health ~= m_lastHealth or ammo ~= m_lastAmmo then
    m_flLastEventTime = CurTime() + FADE_IN_TIME
    m_bDimmed = false
    m_lastHealth, m_lastAmmo = health, ammo
  end

  -- fade out if we're dormant
  if not m_bDimmed then
    m_flDim = math.min(m_flDim + RealFrameTime() / FADE_IN_TIME, 1)
    if m_flLastEventTime < CurTime() then m_bDimmed = true end
  else
    m_flDim = math.max(m_flDim - RealFrameTime() / FADE_OUT_TIME, 0)
  end

  -- ammunition warning
  if ammo <= WARNING_THRESHOLD then
    if not m_warnAmmo then
      LocalPlayer():EmitSound(settings.warning_sound, SNDLVL_NONE, nil, nil, CHAN_ITEM)
      m_ammoFade = CurTime() + EVENT_DURATION
      m_warnAmmo = true
    end
  else
    m_warnAmmo = false
  end

  -- health warning
  if health <= WARNING_THRESHOLD then
    if not m_warnHealth then
      LocalPlayer():EmitSound(settings.warning_sound, SNDLVL_NONE, nil, nil, CHAN_ITEM)
      m_healthFade = CurTime() + EVENT_DURATION
      m_warnHealth = true
    end
  else
    m_warnHealth = false
  end
end

--[[------------------------------------------------------------------
	Draws a progress bar with background.
  @param {number} x
  @param {number} y
  @param {number} filling percentage
  @param {string} background icon font
  @param {string} background icon
  @param {string} foreground icon font
  @param {string} foreground icon
  @param {TEXT_ALIGN_} icon alignment
  @param {Color} colour
]]--------------------------------------------------------------------
local function DrawIconProgressBar(x, y, amount, bgfont, bgchar, fgfont, fgchar, align, colour)
  -- background icon
  surface.SetFont(bgfont)
  local w, h = surface.GetTextSize(bgchar)
  local xpos, ypos = x, y - math.floor(h * .5)
  if align == TEXT_ALIGN_RIGHT then xpos = x - w end
  render.SetScissorRect(xpos, ypos, xpos + w, ypos + h * (1 - amount), true)
  draw.SimpleText(bgchar, bgfont, x, y, colour, align, TEXT_ALIGN_CENTER)
  render.SetScissorRect(0, 0, 0, 0, false)

  -- foreground icon
  surface.SetFont(fgfont)
  local w, h = surface.GetTextSize(fgchar)
  local xpos, ypos = x, y - math.floor(h * .5)
  if align == TEXT_ALIGN_RIGHT then xpos = x - w end
  render.SetScissorRect(xpos, ypos + h * (1 - amount), xpos + w, ypos + h, true)
  draw.SimpleText(fgchar, fgfont, x, y, colour, align, TEXT_ALIGN_CENTER)
  render.SetScissorRect(0, 0, 0, 0, false)
end

function ELEMENT:Draw(settings, scale)
  if LocalPlayer():InVehicle() then return end
  local x, y = ScrW() * .5, ScrH() * .5
  surface.SetAlphaMultiplier(m_flAlpha * (BRIGHTNESS_DIM + (BRIGHTNESS_FULL - BRIGHTNESS_DIM) * m_flDim) / 255)
  -- health bar
  local colour = m_healthColour
  if m_warnHealth then colour = m_warnColour end
  DrawIconProgressBar(x - settings.xpos * scale, y, m_health, self.fonts.font, settings.left_bracket_empty, self.fonts.font, settings.left_bracket, TEXT_ALIGN_RIGHT, colour)
  -- ammo bar
  local colour = m_ammoColour
  if m_warnAmmo then colour = m_warnColour end
  DrawIconProgressBar(x + math.floor(settings.xpos * scale), y, m_ammo, self.fonts.font, settings.right_bracket_empty, self.fonts.font, settings.right_bracket, TEXT_ALIGN_LEFT, colour)
  surface.SetAlphaMultiplier(1)
end
