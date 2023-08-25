
if SERVER then return end

local CLASS_AIRBOAT = 'prop_vehicle_airboat'
local CROSSHAIR_CONVAR = GetConVar('crosshair')

local ELEMENT = HL2HUD.elements.Register('HudCrosshair', 'CHudCrosshair')

ELEMENT:Boolean('visible')
ELEMENT:Font('font')
ELEMENT:String('crosshair')
ELEMENT:Colour('color')
ELEMENT:Number('xoffset')
ELEMENT:Number('yoffset')

function ELEMENT:ShouldDraw(settings)
  local localPlayer = LocalPlayer()
  if GetViewEntity() ~= localPlayer then return false end

  -- in vehicle
  local inVehicle, vehicle = localPlayer:InVehicle(), localPlayer:GetVehicle()
  if (inVehicle and vehicle:GetClass() ~= CLASS_AIRBOAT) or localPlayer:IsFrozen() or not CROSSHAIR_CONVAR:GetBool() then return false end

  -- using a weapon with custom crosshair
  local weapon = localPlayer:GetActiveWeapon()
  if IsValid(weapon) and weapon:IsScripted() then
    if not weapon.DrawCrosshair then return false end
    if weapon.DoDrawCrosshair and weapon:DoDrawCrosshair(0, 0) then
      return false
    end
  end
  return settings.visible
end

function ELEMENT:Draw(settings, scale)
  local x, y = ScrW() * .5, ScrH() * .5
  local localPlayer = LocalPlayer()

  -- support for SWEP.AccurateCrosshair
  local weapon = localPlayer:GetActiveWeapon()
  if IsValid(weapon) and weapon:IsScripted() and weapon.AccurateCrosshair then
    local pos = localPlayer:GetEyeTrace().HitPos:ToScreen()
    x = pos.x
    y = pos.y
  end

  -- change crosshair position while driving the airboat
  local inVehicle, vehicle = localPlayer:InVehicle(), localPlayer:GetVehicle()
  if inVehicle and vehicle:GetClass() == CLASS_AIRBOAT and not localPlayer:GetAllowWeaponsInVehicle() then
    -- nullify one of the angles
    local ang = vehicle:GetAngles()
    ang.z = 0

    -- calculate crosshair position
    local pos = (vehicle:GetPos() + ang:Up() * 62.4 + ang:Right() * -256):ToScreen()
    x = pos.x
    y = pos.y
  end

  -- draw crosshair
  draw.SimpleText(settings.crosshair, self.fonts.font, x + settings.xoffset * scale, y + settings.yoffset * scale, self.colours[settings.color], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
