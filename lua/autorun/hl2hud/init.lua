HL2HUD.include('hudelement.lua')
HL2HUD.include('animationcontroller.lua')
HL2HUD.include('fonts.lua')
HL2HUD.include('ischeme.lua')
HL2HUD.include('clientscheme.lua')
HL2HUD.include('override.lua')
HL2HUD.include('util.lua')
HL2HUD.include('bind_press.lua')
HL2HUD.include('weapon_switcher.lua')

HL2HUD.include('vgui/dbuttonedline.lua')
HL2HUD.include('vgui/dcolormixerbutton.lua')
HL2HUD.include('vgui/dcolorcombo.lua')
HL2HUD.include('vgui/dframe.lua')
HL2HUD.include('vgui/dlist.lua')
HL2HUD.include('vgui/dlistline.lua')
HL2HUD.include('vgui/dpreview.lua')
HL2HUD.include('vgui/dfonteditor.lua')
HL2HUD.include('vgui/dresourcelist.lua')
HL2HUD.include('vgui/about.lua')
HL2HUD.include('vgui/clientscheme/dcolor.lua')
HL2HUD.include('vgui/clientscheme/dfont.lua')
HL2HUD.include('vgui/layout/dparameter.lua')
HL2HUD.include('vgui/layout/dcheckbox.lua')
HL2HUD.include('vgui/layout/dcolour.lua')
HL2HUD.include('vgui/layout/dfont.lua')
HL2HUD.include('vgui/layout/dnumber.lua')
HL2HUD.include('vgui/layout/doption.lua')
HL2HUD.include('vgui/layout/dstring.lua')
HL2HUD.include('vgui/animations/dcommand.lua')
HL2HUD.include('vgui/animations/dedit.lua')
HL2HUD.include('vgui/animations/commands/dcommand.lua')
HL2HUD.include('vgui/animations/commands/danim.lua')
HL2HUD.include('vgui/animations/editors/danimeditor.lua')
HL2HUD.include('vgui/animations/editors/dcommandeditor.lua')
HL2HUD.include('vgui/textures/diconeditor.lua')
HL2HUD.include('vgui/textures/dspriteeditor.lua')
HL2HUD.include('vgui/textures/dtextureeditor.lua')
HL2HUD.include('vgui/textures/dtexturelist.lua')

HL2HUD.include('qmenu/menu.lua')
HL2HUD.include('qmenu/toolmenu.lua')
HL2HUD.include('qmenu/contextmenu.lua')

HL2HUD.include('elements/health.lua')
HL2HUD.include('elements/battery.lua')
HL2HUD.include('elements/ammo.lua')
HL2HUD.include('elements/ammo2.lua')
HL2HUD.include('elements/auxpow.lua')
HL2HUD.include('elements/flashlight.lua')
HL2HUD.include('elements/weapon_selector.lua')
HL2HUD.include('elements/poison.lua')
HL2HUD.include('elements/hint.lua')
HL2HUD.include('elements/crosshair.lua')
HL2HUD.include('elements/vehicle.lua')
HL2HUD.include('elements/quickinfo.lua')
HL2HUD.include('elements/zoom.lua')
HL2HUD.include('elements/squad.lua')
HL2HUD.include('elements/pickup.lua')
HL2HUD.include('elements/damage.lua')

-- Half-Life 2 schemes
HL2HUD.include('schemes/default.lua')
HL2HUD.include('schemes/halflife2.lua')
HL2HUD.include('schemes/retail.lua')
HL2HUD.include('schemes/prerelease.lua')
HL2HUD.include('schemes/icons.lua')
HL2HUD.include('schemes/compact.lua')

-- Sourcemod schemes
HL2HUD.include('schemes/ez.lua')
HL2HUD.include('schemes/ez2.lua')
HL2HUD.include('schemes/gstring.lua')
HL2HUD.include('schemes/gstringbeta.lua')
HL2HUD.include('schemes/eleveneightyseven.lua')
HL2HUD.include('schemes/smod.lua')
HL2HUD.include('schemes/cdestiny.lua')

-- Custom schemes
HL2HUD.include('schemes/blackmesa.lua')
HL2HUD.include('schemes/cstrike.lua')
HL2HUD.include('schemes/bluemoon.lua')
HL2HUD.include('schemes/coolvetica.lua')
HL2HUD.include('schemes/sbox.lua')
HL2HUD.include('schemes/lcd.lua')
HL2HUD.include('schemes/nv.lua')
HL2HUD.include('schemes/sports.lua')
HL2HUD.include('schemes/hl1.lua')
HL2HUD.include('schemes/hl1b.lua')
HL2HUD.include('schemes/hl1c.lua')

-- load third-party add-ons
local files, directories = file.Find('autorun/hl2hud/add-ons/*.lua', 'LUA')
for _, file in pairs(files) do
  HL2HUD.include('add-ons/' .. file)
end

if SERVER then return end

-- [[ Console variables ]] --
local hl2hud_enabled = CreateClientConVar('hl2hud_enabled', 1)
local hl2hud_nosuit = CreateClientConVar('hl2hud_nosuit', 0)
local hl2hud_alwayshide = CreateClientConVar('hl2hud_alwayshide', 1)

-- [[ Initialization ]] --
HL2HUD.settings.Init()
local settings = HL2HUD.settings.Get()

--[[------------------------------------------------------------------
  Whether the HUD is visible.
  @return {boolean} is visible
]]--------------------------------------------------------------------
local cl_drawhud = GetConVar('cl_drawhud')
function HL2HUD.ShouldDraw()
  return hl2hud_enabled:GetBool() and cl_drawhud:GetBool()
end

--[[------------------------------------------------------------------
  Whether the player has the suit equipped.
  @return {boolean} is suit equipped
]]--------------------------------------------------------------------
function HL2HUD.IsSuitEquipped()
  local localPlayer = LocalPlayer()
  if not IsValid(localPlayer) then return end
  return (hl2hud_nosuit:GetBool() or localPlayer:IsSuitEquipped()) and localPlayer:Alive()
end

--[[------------------------------------------------------------------
  Whether the given element should be visible.
  @return {boolean} is element visible
]]--------------------------------------------------------------------
function HL2HUD.ShouldDrawElement(element)
  return HL2HUD.elements.Get(element):ShouldDraw(settings.HudLayout[element])
end

-- [[ Run animations before drawing the HUD ]] --
hook.Add('PreDrawHUD', HL2HUD.hookname, function()
  if not HL2HUD.ShouldDraw() or not HL2HUD.IsSuitEquipped() then return end
  HL2HUD.animations.UpdateAnimations()
  for name, element in HL2HUD.elements.Iterator() do
    element:PreDraw(params)
  end
end)

-- [[ Draw HUD elements ]] --
hook.Add('HUDPaint', HL2HUD.hookname, function()
  if not HL2HUD.ShouldDraw() then return end
  for name, element in HL2HUD.elements.Iterator() do
    local params = settings.HudLayout[name]
    if not element:ShouldDraw(params) then continue end
    element:OnThink(params)
    if element.OnTop or (not element.DrawAlways and not HL2HUD.IsSuitEquipped()) then continue end
    element:Draw(params, HL2HUD.Scale())
  end
end)

-- [[ Draw HUD elements overriding HUDShouldDraw ]] --
hook.Add('DrawOverlay', HL2HUD.hookname, function()
  if not HL2HUD.ShouldDraw() then return end
  if gui.IsGameUIVisible() then return end
  for name, element in HL2HUD.elements.Iterator() do
    if not element.OnTop then continue end
    if not element.DrawAlways and not HL2HUD.IsSuitEquipped() then continue end
    local params = settings.HudLayout[name]
    if not element:ShouldDraw(params) then continue end
    element:Draw(params, HL2HUD.Scale())
  end
end)

-- [[ Hide CHud elements ]] --
hook.Add('HUDShouldDraw', HL2HUD.hookname, function(default)
  if not HL2HUD.ShouldDraw() then return end
  if CHudScan then return end
  local replacer = HL2HUD.elements.CHudReplacer(default)
  if not replacer then return end
  if not replacer:ShouldDraw(settings.HudLayout[replacer.name]) then return end
  return false
end)
