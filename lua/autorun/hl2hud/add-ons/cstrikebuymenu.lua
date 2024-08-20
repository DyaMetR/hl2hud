--[[------------------------------------------------------------------
  Support for Goldsrc Counter-Strike Buymenu.
  https://steamcommunity.com/sharedfiles/filedetails/?id=3311934020
]]--------------------------------------------------------------------

if SERVER then return end

hook.Add('HL2HUD_GetAccountMoney', 'cstrikebuymenu', function()
  local money = LocalPlayer():GetNW2Int('cstrike_money', -1)
  if money == -1 then return end
  return money
end)

hook.Add('CStrike_MoneyHUD', 'hl2hud', function()
  if not HL2HUD.ShouldDraw() then return end
  return true
end)