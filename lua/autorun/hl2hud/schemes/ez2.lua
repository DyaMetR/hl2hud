
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(255, 244, 244),
  FgColor = Color(255, 244, 244, 100),
  BrightFg = Color(244, 36, 28),
  BrightBg = Color(255, 244, 244, 80),
  SelectionNumberFg = Color(255, 244, 244),
  SelectionTextFg = Color(255, 36, 28),
  AuxPowerHighColor = Color(255, 244, 244, 220),
  SquadMemberAdded = Color(255, 244, 244),
  SquadMember = Color(255, 244, 244, 160),
  ZoomReticleColor = Color(255, 244, 244)
})

SCHEME:Font('WeaponIconsMP', 'HL2MP', 64, 0, true)
SCHEME:Font('WeaponIconsSelected', 'HL2MP', 64, 0, true, 2)
SCHEME:Font('WeaponIconsSmallMP', 'HL2MP', 32, 0, true)
SCHEME:Font('EZ2', 'ez2_hud', 56, 0, true)
SCHEME:Font('EZ2Selected', 'ez2_hud', 56, 0, true, 2)
SCHEME:Font('EZ2Small', 'ez2_hud', 24, 0, true)
SCHEME:Font('HudNumbers', 'Frak', 32, 0, true)
SCHEME:Font('HudNumbersGlow', 'Frak', 32, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'Frak', 16, 1000, true)
SCHEME:Font('HudHintTextSmall', 'Frak', 9, 1000)

SCHEME:Font('HudNumbers', 'Frak', 32, 0, true)
SCHEME:Font('HudNumbersGlow', 'Frak', 32, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'Frak', 16, 1000, true)
SCHEME:Font('HudHintTextSmall', 'Frak', 9, 1000)
SCHEME:Font('HudSelectionNumbers', 'Frak', 11, 700)
SCHEME:Font('HudSelectionText', 'Frak', 7, 1000)

SCHEME:Layout({
  HudHealth = {
    text = 'STIMDOSE'
  },
  HudSuit = {
    text = 'SHIELDS'
  },
  HudAmmo = {
    icon_visible = true,
    digit_xpos = 44
  },
  HudAmmoSecondary = {
    wide = 60,
    icon_visible = true
  },
  HudWeaponSelection = {
    compact = false,
    uppercase = true,
    TextYPos = 64,
    TextAlign = 1,
    MoveSnd = 'hl2hud/ez2/wpn_moveselect.wav',
    SelectSnd = 'hl2hud/ez2/wpn_hudoff.wav'
  },
  HudHistoryResource = {
    Episodic = true,
    ShowMissingIcons = false
  },
  HUDQuickInfo = {
    visible = true,
    left_bracket = '',
    left_bracket_empty = '',
    right_bracket = '',
    right_bracket_empty = '',
    warning_sound = 'hl2hud/ez2/warning.wav'
  }
})

SCHEME:Animations({
  Init = {
    { 'Animate', 'HudWeaponSelection', 'SelectedFgColor', 'SelectionNumberFg', 'Linear', 0, .01 }
  },
  WeaponUsesSecondaryAmmo = {
    { 'StopAnimation', 'HudAmmo', 'Position', 0 },
    { 'StopAnimation', 'HudAmmo', 'Size', 0 },
    { 'StopPanelAnimations', 'HudAmmoSecondary', 0 },
    { 'Animate', 'HudAmmoSecondary', 'BgColor', 'BrightBg', 'Linear', 0, .1 },
    { 'Animate', 'HudAmmoSecondary', 'BgColor', 'BgColor', 'Deaccel', .1, 1 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .1 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Linear', .2, 1.5 },
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 255, 'Linear', 0, .1 },
  	{ 'Animate', 'HudAmmo', 'Position', Vector(60, 0), 'Deaccel', 0, .5 },
  	{ 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
  }
})

-- [[ Half-Life 2 weapon icons ]] --
local WEAPONS = {
  weapon_stunstick = 'a',
  weapon_pistol = 'b',
  weapon_357 = 'd',
  weapon_smg1 = 'e',
  weapon_ar2 = 'g',
  weapon_shotgun = 'h',
  weapon_crossbow = 'l',
  weapon_rpg = 'i',
  weapon_frag = 'm',
  weapon_slam = 'j'
}
for id, _ in pairs(HL2HUD.utils.DefaultIcons.ammo) do
  local class, font = HL2HUD.utils.DefaultIcons.ammoWeapon[id], 'WeaponIconsSmallMP'
  local x, y = -4, 6
  local weapon = HL2HUD.utils.AltIcons[class]
  if WEAPONS[class] then
    weapon = WEAPONS[class]
    font = 'EZ2Small'
    x = 0
    y = 0
  end
  if weapon then SCHEME:AmmoWeaponIcon(id, font, weapon, x, y) end
end
for class, icon in pairs(HL2HUD.utils.AltIcons) do
  local font1, font2 = 'WeaponIconsMP', 'WeaponIconsSelected'
  local offset = 12
  if WEAPONS[class] then
    icon = WEAPONS[class]
    font1 = 'EZ2'
    font2 = 'EZ2Selected'
    offset = 0
  end
  SCHEME:WeaponIcon(class, font1, icon, font2, nil, nil, offset)
end

--[[------------------------------------------------------------------
  Entropy Zero 2 SWEPs support
  https://steamcommunity.com/sharedfiles/filedetails/?id=2856656789
]]--------------------------------------------------------------------
local SWEPs = {
  ez2cwep_magnum = 'd',
  ez2cwep_ar2 = 'g',
  ez2cwep_ar2_proto = 'g',
  ez2cwep_crossbow = 'l',
  ez2cwep_grenade = 'm',
  ez2cwep_mp5 = 'f',
  ez2cwep_pistol = 'b',
  ez2cwep_pulse_pistol = 'c',
  ez2cwep_rpg = 'i',
  ez2cwep_slam = 'j',
  ez2cwep_shotgun = 'h',
  ez2cwep_smg = 'e',
  tfa_ez2_magnum = 'd',
  tfa_ez2_ar2 = 'g',
  tfa_ez2_ar2_proto = 'g',
  tfa_ez2_crossbow = 'l',
  tfa_ez2_grenade = 'm',
  tfa_ez2_mp5 = 'f',
  tfa_ez2_pistol = 'b',
  tfa_ez2_pulse_pistol = 'c',
  tfa_ez2_rpg = 'i',
  tfa_ez2_slam = 'j',
  tfa_ez2_shotgun = 'h',
  tfa_ez2_smg = 'e'
}
for class, icon in pairs(SWEPs) do
  SCHEME:WeaponIcon(class, 'EZ2', icon, 'EZ2Selected', nil, nil, 0)
end

HL2HUD.scheme.Register('Entropy Zero 2', SCHEME)
