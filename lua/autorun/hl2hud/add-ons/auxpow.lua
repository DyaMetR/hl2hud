--[[------------------------------------------------------------------
  Support for H.E.V Mk V Auxiliary Power addon
  https://steamcommunity.com/sharedfiles/filedetails/?id=1758584347
]]--------------------------------------------------------------------

if SERVER then return end

if not AUXPOW then return end

local HOOK = 'auxpow'

-- [[ Get addon information and hide its HUD ]] --
local power, labels = 1, {}
hook.Add('AuxPowerHUDPaint', HL2HUD.hookname, function(_power, _labels)
  if not HL2HUD.ShouldDraw() or not HL2HUD.ShouldDrawElement('HudSuitPower') then return end
  power = _power
  labels = table.ClearKeys(_labels) -- WORKAROUND: a way to circumvent string keys at the cost of creating a table each frame
  return true
end)

-- [[ Get flashlight information and hide its HUD ]] --
local flashlight = 1
hook.Add('EP2FlashlightHUDPaint', HL2HUD.hookname, function(_power)
  if not HL2HUD.ShouldDraw() or not HL2HUD.ShouldDrawElement('HudFlashlight') then return end
  flashlight = _power
  return true
end)

-- [[ Override aux power amount ]] --
hook.Add('HL2HUD_GetAuxPower', HOOK, function()
  if not AUXPOW:IsEnabled() then return end
  return power
end)

-- [[ Override aux power active features labels ]] --
hook.Add('HL2HUD_GetAuxPowerActions', HOOK, function()
  if not AUXPOW:IsEnabled() then return end
  return labels
end)

-- [[ Enable flashlight indicator ]] --
hook.Add('HL2HUD_ShouldDrawFlashlight', HOOK, function()
  if not AUXPOW:IsEnabled() or not AUXPOW:IsEP2Mode() then return end
  return true
end)

-- [[ Override flashlight amount ]] --
hook.Add('HL2HUD_GetFlashlight', HOOK, function()
  if not AUXPOW:IsEnabled() or not AUXPOW:IsEP2Mode() then return end
  return flashlight
end)
