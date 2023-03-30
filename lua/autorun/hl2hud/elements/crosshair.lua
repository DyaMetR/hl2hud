
if SERVER then return end

local CLASS_AIRBOAT = 'prop_vehicle_airboat'
local CROSSHAIR_CONVAR = GetConVar('crosshair')

local ELEMENT = HL2HUD.elements.Register('HudCrosshair', 'CHudCrosshair')

ELEMENT:Boolean('visible')
ELEMENT:Font('font')
ELEMENT:String('crosshair')
ELEMENT:Colour('color')

function ELEMENT:Draw(settings, scale)
  local inVehicle, vehicle = LocalPlayer():InVehicle(), LocalPlayer():GetVehicle()
  if (inVehicle and vehicle:GetClass() ~= CLASS_AIRBOAT) or LocalPlayer():IsFrozen() or not CROSSHAIR_CONVAR:GetBool() then return end
  local x, y = ScrW() * .5, ScrH() * .5

  -- change crosshair position while driving the airboat
  if inVehicle and vehicle:GetClass() == CLASS_AIRBOAT then
    -- nullify one of the angles
    local ang = vehicle:GetAngles()
    ang.z = 0

    -- calculate crosshair position
    local pos = (vehicle:GetPos() + ang:Up() * 62.4 + ang:Right() * -256):ToScreen()
    x = pos.x
    y = pos.y
  end

  -- draw crosshair
  draw.SimpleText(settings.crosshair, self.fonts.font, x, y, self.colours[settings.color], TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end
