--[[------------------------------------------------------------------
  "Hey! This isn't the real HudDamageIndicator!"
  You're right. I'm sorry. This is just adding the death screen.
]]--------------------------------------------------------------------

local HOOK = HL2HUD.hookname .. 'HudDamageIndicator'

if SERVER then

  util.AddNetworkString(HOOK)

  hook.Add('EntityTakeDamage', HOOK, function(_player, damage)
    if not IsValid(_player) or not _player:IsPlayer() then return end
    if not damage:IsFallDamage() or damage:GetDamage() < _player:Health() then return end
    net.Start(HOOK)
    net.Send(_player)
  end)

end

if SERVER then return end

local ELEMENT = HL2HUD.elements.Register('HudDamageIndicator')

ELEMENT.DrawAlways = true

ELEMENT:Boolean('visible')

local fallDamage = false
local respawned = true

function ELEMENT:ShouldDraw(settings)
  if not settings.visible then return false end
  local localPlayer = LocalPlayer()
  local alive = IsValid(localPlayer) and localPlayer:Alive()
  if alive and not respawned then -- reset fall damage status
    respawned = false
    fallDamage = false
  end
  return not alive
end

local COLOUR = Color(0, 0, 0)
function ELEMENT:Draw(settings)
  if not fallDamage then return end
  draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), COLOUR)
  respawned = false
end

-- [[ Put camera on the floor if enabled ]] --
local OFFSET = Vector(0, 0, 5)
hook.Add('CalcView', HOOK, function(_player, pos, ang, fov)
  if not HL2HUD.ShouldDraw() or not ELEMENT:ShouldDraw(HL2HUD.settings.Get().HudLayout.HudDamageIndicator) then return end
  local view = {}
  view.origin = _player:GetPos() + OFFSET
  local ragdoll = LocalPlayer():GetRagdollEntity()
  if IsValid(ragdoll) then ragdoll:SetNoDraw(true) end
  return view
end)

-- [[ Receive fall damage ]] --
net.Receive(HOOK, function(len)
  fallDamage = true
end)
