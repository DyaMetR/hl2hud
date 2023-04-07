
if SERVER then return end

local ELEMENT = HL2HUD.elements.Register('HudAmmoSecondary', 'CHudSecondaryAmmo')

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
ELEMENT:Boolean('icon_visible')
ELEMENT:Boolean('icon_abspos')
ELEMENT:Number('icon_xpos')
ELEMENT:Number('icon_ypos')

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

local m_iAmmo, m_iType = -1, 0
function ELEMENT:Init()
	self:Variable('BgColor', table.Copy(self.colours.BgColor))
	self:Variable('FgColor', table.Copy(self.colours.FgColor))
  self:Variable('Position', Vector(0, 0))
  self:Variable('Size', Vector(0, 0))
  self:Variable('Blur', 0)
  self:Variable('Alpha', 0)
  m_iAmmo = -1
  m_iType = 0
end

local function GetAmmo()
  if LocalPlayer():InVehicle() then return 0, 0 end
  local weapon = LocalPlayer():GetActiveWeapon()
  if not IsValid(weapon) then return 0, 0 end
  if weapon:IsScripted() then
    if weapon.DrawAmmo == false then return 0, 0 end
    local ammo = weapon:CustomAmmoDisplay()
    if ammo then
      if not ammo.Draw then return 0, 0 end
      if not ammo.SecondaryAmmo then return 0, 0 end
      return 0, ammo.SecondaryAmmo, true
    end
  end
  local ammo = weapon:GetSecondaryAmmoType() or 0
  return ammo, LocalPlayer():GetAmmoCount(ammo) or 0
end

function ELEMENT:OnThink()
  local ammotype, ammo, custom = GetAmmo()

  -- ammo changed
  if m_iAmmo ~= ammo then
    if ammo <= 0 then
      HL2HUD.animations.StartAnimationSequence('AmmoSecondaryEmpty')
    elseif ammo > m_iAmmo then
      HL2HUD.animations.StartAnimationSequence('AmmoSecondaryIncreased')
    else
      HL2HUD.animations.StartAnimationSequence('AmmoSecondaryDecreased')
    end
    m_iAmmo = ammo
  end

  -- weapon changed
	if ammotype ~= m_iType then
    if ammotype <= 0 and not custom then
      HL2HUD.animations.StartAnimationSequence('WeaponDoesNotUseSecondaryAmmo')
    else
      HL2HUD.animations.StartAnimationSequence('WeaponUsesSecondaryAmmo')
    end
    m_iType = ammotype
  end
end

function ELEMENT:Draw(settings, scale)
	local weapon = LocalPlayer():GetActiveWeapon()
	if not IsValid(weapon) or LocalPlayer():InVehicle() then return end
  local ammotype, reserve = GetAmmo()
	local x, y = (settings.xpos + self.variables.Position.x) * scale, (settings.ypos + self.variables.Position.y) * scale
	local w, h = (settings.wide + self.variables.Size.x) * scale, (settings.tall + self.variables.Size.y) * scale
  local text = language.GetPhrase(settings.text)
  local align
	if settings.halign > 1 then x = ScrW() - (x + w) end
	if settings.valign > 1 then y = ScrH() - (y + h) end
  if settings.digit_align > 1 then align = TEXT_ALIGN_RIGHT end
  render.SetScissorRect(x, y, x + w, y + h, true)
  surface.SetAlphaMultiplier(self.variables.Alpha / 255)
	draw.RoundedBox(8, x, y, w, h, self.variables.BgColor)
	HL2HUD.utils.DrawGlowingText(self.variables.Blur, reserve, self.fonts.digit_font, self.fonts.digit_font_glow, x + settings.digit_xpos * scale, y + settings.digit_ypos * scale, self.variables.FgColor, self.variables.FgColor, align)
	draw.SimpleText(language.GetPhrase(settings.text), self.fonts.text_font, x + settings.text_xpos * scale, y + settings.text_ypos * scale, self.variables.FgColor)
	local icon = self.icons.AmmoInv[game.GetAmmoName(ammotype)]
  if settings.icon_visible and icon then
    if not settings.icon_abspos then -- make position relative to the ALT text
      surface.SetFont(self.fonts.text_font)
      x = x + settings.text_xpos * scale + surface.GetTextSize(text) * .5
      y = y + settings.text_ypos * scale
    end
    HL2HUD.utils.DrawIcon(icon, x + settings.icon_xpos * scale, y + settings.icon_ypos * scale, self.variables.FgColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
  surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end
