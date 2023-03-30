-- TODO: remove this file

if SERVER then return end

if engine.ActiveGamemode() ~= 'terrortown' then return end

local HOOK = 'ttt'

--[[ Hide TTT HUD ]]--
local hide = { ['TTTInfoPanel'] = true, ['TTTPickupHistory'] = true }
hook.Add('HUDShouldDraw', HL2HUD.hookname .. HOOK, function(element)
  if not HL2HUD.IsVisible() then return end
  if hide[element] then return false end
end)

--[[ Role colours ]]--
local COLOURS = {
  Color(64, 255, 64),
  Color(255, 64, 64),
  Color(64, 128, 255)
}

--[[ Generate simple schemes for each role ]]--
local SCHEMES = {}
for role, colour in pairs(COLOURS) do
  SCHEMES[role] = {
    ClientScheme = {
      Colors = {
        Normal = colour,
        FgColor = Color(colour.r, colour.g, colour.b, 160),
        BrightFg = colour,
        BrightBg = colour,
        SelectionNumberFg = colour,
        SelectionTextFg = colour,
        AuxPowerHighColor = colour,
        SquadMemberAdded = colour,
        SquadMember = Color(colour.r, colour.g, colour.b, 160),
        ZoomReticleColor = colour
      }
    }
  }
end

local current = -1
hook.Add('HUDPaint', HL2HUD.hookname .. HOOK, function()
  if not LocalPlayer().Team or LocalPlayer():Team() == TEAM_SPEC or not LocalPlayer().GetRole or LocalPlayer():GetRole() == current then return end
  current = LocalPlayer():GetRole()
  HL2HUD.override.Submit(HOOK, SCHEMES[current + 1])
end)
