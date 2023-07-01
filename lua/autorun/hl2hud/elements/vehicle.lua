
local NET = HL2HUD.hookname .. '_vehicle_crosshair'

local NWVAR_ENABLE = 'EnableGun'
local NWVAR_FIRE = 'm_bUnableToFire'
local NWVAR_CROSSHAIR = 'm_vecGunCrosshair'

if SERVER then

  util.AddNetworkString(NET)

  -- [[ Update whether the vehicle has a weapon ]] --
  hook.Add('PlayerEnteredVehicle', HL2HUD.hookname, function(_player, vehicle, role)
    vehicle:SetNWBool(NWVAR_ENABLE, vehicle:GetInternalVariable(NWVAR_ENABLE))
  end)

  -- [[ Update player driven vehicles weapon status ]] --
  hook.Add('Tick', HL2HUD.hookname, function()
    for _, ply in pairs(player.GetAll()) do
      if not IsValid(ply) or not ply:InVehicle() or not IsValid(ply:GetVehicle()) then continue end
      local vehicle = ply:GetVehicle()
      if not vehicle:IsVehicle() or not IsValid(vehicle:GetDriver()) or vehicle:GetDriver() != ply or not vehicle:GetInternalVariable(NWVAR_ENABLE) then continue end
      vehicle:SetNWBool(NWVAR_FIRE, vehicle:GetInternalVariable(NWVAR_FIRE))
      net.Start(NET)
      net.WriteVector(vehicle:GetInternalVariable(NWVAR_CROSSHAIR) - vehicle:GetPos())
      net.Send(vehicle:GetDriver())
    end
  end)

end

if SERVER then return end

local ELEMENT = HL2HUD.elements.Register('HudVehicle', 'CHudVehicle')

ELEMENT:Boolean('visible')
ELEMENT:Number('wide')
ELEMENT:Number('tall')
ELEMENT:String('crosshair')
ELEMENT:Colour('color')
ELEMENT:Colour('unable')

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

local crosshair
function ELEMENT:Init(settings)
  crosshair = surface.GetTextureID(settings.crosshair)
end

local vector = Vector(0, 0, 0)
local current, target = Vector(0, 0), Vector(0, 0)
function ELEMENT:Draw(settings, scale)
  if not LocalPlayer():InVehicle() or not crosshair then return end -- are we in a vehicle? is the crosshair valid?
  local vehicle = LocalPlayer():GetVehicle()
  if not vehicle:GetNWBool(NWVAR_ENABLE) then return end -- is there a weapon?
  local colour = self.colours[settings.color]
  if vehicle:GetNWBool(NWVAR_FIRE) then colour = self.colours[settings.unable] end -- change colour if we can't shoot

  -- calculate crosshair position
  local toscreen = (vector + vehicle:GetPos()):ToScreen()
  target.x = toscreen.x
  target.y = toscreen.y
  current = LerpVector(0.5, current, target)

  -- draw crosshair
  surface.SetTexture(crosshair)
  surface.SetDrawColor(colour)
  surface.DrawTexturedRect(current.x - settings.wide * .5, current.y - settings.tall * .5, settings.wide, settings.tall)
end

-- [[ Receive aiming vector ]] --
net.Receive(NET, function()
  vector = net.ReadVector()
end)
