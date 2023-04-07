
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

local override = false

function ELEMENT:PreDraw(settings)
  override = false
  local localPlayer = LocalPlayer()
  if not IsValid(localPlayer) then return end
  local weapon = localPlayer:GetActiveWeapon()
  if not IsValid(weapon) or not weapon:IsScripted() then return end
  if not weapon.DrawCrosshair then
    override = true
    return
  end
  if not weapon.DoDrawCrosshair then return end
  override = weapon:DoDrawCrosshair(0, 0) or false
end

function ELEMENT:ShouldDraw(settings)
  local localPlayer = LocalPlayer()
  local inVehicle, vehicle = localPlayer:InVehicle(), localPlayer:GetVehicle()
  if (inVehicle and vehicle:GetClass() ~= CLASS_AIRBOAT) or localPlayer:IsFrozen() or not CROSSHAIR_CONVAR:GetBool() then return false end
  return settings.visible and not override
end

function ELEMENT:Draw(settings, scale)
  local x, y = ScrW() * .5, ScrH() * .5

  -- change crosshair position while driving the airboat
  local inVehicle, vehicle = LocalPlayer():InVehicle(), LocalPlayer():GetVehicle()
  if inVehicle and vehicle:GetClass() == CLASS_AIRBOAT and not LocalPlayer():GetAllowWeaponsInVehicle() then
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
