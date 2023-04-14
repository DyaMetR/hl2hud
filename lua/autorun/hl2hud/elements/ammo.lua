
if SERVER then return end

local ELEMENT = HL2HUD.elements.Register('HudAmmo', 'CHudAmmo')

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
ELEMENT:Number('digit2_xpos')
ELEMENT:Number('digit2_ypos')
ELEMENT:Font('digit2_font')
ELEMENT:Alignment('digit2_align')
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

local m_iAmmo, m_eWeapon = -1, NULL
function ELEMENT:Init()
	self:Variable('BgColor', table.Copy(self.colours.BgColor))
	self:Variable('FgColor', table.Copy(self.colours.FgColor))
  self:Variable('Position', Vector(0, 0))
  self:Variable('Size', Vector(0, 0))
  self:Variable('Blur', 0)
  self:Variable('Alpha', 255)
  m_iAmmo = -1
	m_eWeapon = NULL
end

local function GetAmmo()
  -- vehicle ammo
  if LocalPlayer():InVehicle() and not LocalPlayer():GetAllowWeaponsInVehicle() then
    local vehicle = LocalPlayer():GetVehicle()
    if not vehicle.GetAmmo then return -1, -1, 0 end
    local primary, _, reserve = vehicle:GetAmmo()
    return reserve or -1, -1, primary or 0
  end

  -- is weapon valid?
  local weapon = LocalPlayer():GetActiveWeapon()
	if not IsValid(weapon) then return -1, -1, 0 end

  -- custom ammo display
  if weapon:IsScripted() then
    if weapon.DrawAmmo == false then return -1, -1, 0 end
    local ammo = weapon:CustomAmmoDisplay()
    if ammo then
      return ammo.PrimaryClip or -1, ammo.PrimaryAmmo or -1, weapon:GetPrimaryAmmoType() or 0, ammo.Draw and (ammo.PrimaryClip or ammo.PrimaryAmmo)
    end
  end

  -- default ammo display
	local primary = weapon:GetPrimaryAmmoType() or 0
	local clip, reserve = weapon:Clip1() or -1, LocalPlayer():GetAmmoCount(primary) or -1
	if clip < 0 then return reserve, -1, primary end
	return clip, reserve, primary
end

function ELEMENT:OnThink()
  local weapon = LocalPlayer():GetActiveWeapon()
  if LocalPlayer():InVehicle() then weapon = LocalPlayer():GetVehicle() end
	local clip, reserve, ammotype, custom = GetAmmo()

	-- ammunition amount changed
	if clip ~= m_iAmmo then
		if ammotype > 0 or custom then
			if clip <= 0 then
				HL2HUD.animations.StartAnimationSequence('AmmoEmpty')
			elseif clip > m_iAmmo then
				HL2HUD.animations.StartAnimationSequence('AmmoIncreased')
			else
				HL2HUD.animations.StartAnimationSequence('AmmoDecreased')
			end
		end
		m_iAmmo = clip
	end

	-- weapon changed
	if m_eWeapon ~= weapon then
		if reserve >= 0 then
      HL2HUD.animations.StartAnimationSequence('WeaponUsesClips')
		else
			HL2HUD.animations.StartAnimationSequence('WeaponDoesNotUseClips')
		end
		HL2HUD.animations.StartAnimationSequence('WeaponChanged')
		m_eWeapon = weapon
	end
end

function ELEMENT:Draw(settings, scale)
	local clip, reserve, ammotype, custom = GetAmmo()
	if ammotype <= 0 and not custom then return end
	local x, y = (settings.xpos + self.variables.Position.x) * scale, (settings.ypos + self.variables.Position.y) * scale
	local w, h = (settings.wide + self.variables.Size.x) * scale, (settings.tall + self.variables.Size.y) * scale
  local text = language.GetPhrase(settings.text)
  local align, align2
	if settings.halign > 1 then x = ScrW() - (x + w) end
	if settings.valign > 1 then y = ScrH() - (y + h) end
  if settings.digit_align > 1 then align = TEXT_ALIGN_RIGHT end
  if settings.digit2_align > 1 then align2 = TEXT_ALIGN_RIGHT end
  render.SetScissorRect(x, y, x + w, y + h, true)
  surface.SetAlphaMultiplier(self.variables.Alpha / 255)
	draw.RoundedBox(8, x, y, w, h, self.variables.BgColor)
	HL2HUD.utils.DrawGlowingText(self.variables.Blur, clip, self.fonts.digit_font, self.fonts.digit_font_glow, x + settings.digit_xpos * scale, y + settings.digit_ypos * scale, self.variables.FgColor, self.variables.FgColor, align)
	draw.SimpleText(text, self.fonts.text_font, x + settings.text_xpos * scale, y + settings.text_ypos * scale, self.variables.FgColor)
	if reserve >= 0 then draw.SimpleText(reserve, self.fonts.digit2_font, x + settings.digit2_xpos * scale, y + settings.digit2_ypos * scale, self.variables.FgColor, align2) end
  local icon = self.icons.AmmoInv[game.GetAmmoName(ammotype)]
  if settings.icon_visible and icon then
    if not settings.icon_abspos then -- make position relative to the AMMO text
      surface.SetFont(self.fonts.text_font)
      x = x + settings.text_xpos * scale + surface.GetTextSize(text) * .5
      y = y + settings.text_ypos * scale
    end
    HL2HUD.utils.DrawIcon(icon, x + settings.icon_xpos * scale, y + settings.icon_ypos * scale, self.variables.FgColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  end
  surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end
