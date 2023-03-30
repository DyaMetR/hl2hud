
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
SCHEME:Font('WeaponIconsSelected', 'HL2MP', 64, 0, true, 5)
SCHEME:Font('WeaponIconsSmallMP', 'HL2MP', 32, 0, true)
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
    SkipEmpty = true,
    MoveSnd = 'hl2hud/ez2/wpn_moveselect.wav',
    SelectSnd = 'hl2hud/ez2/wpn_hudoff.wav'
  },
  HudHistoryResource = {
    Episodic = true,
    ShowMissingIcons = false
  },
  HUDQuickInfo = {
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

for id, _ in pairs(HL2HUD.utils.DefaultIcons.ammo) do
  local weapon = HL2HUD.utils.AltIcons[HL2HUD.utils.DefaultIcons.ammoWeapon[id]]
  if weapon then SCHEME:AmmoWeaponIcon(id, 'WeaponIconsSmallMP', weapon, -4, 6) end
end
for class, icon in pairs(HL2HUD.utils.AltIcons) do
  SCHEME:WeaponIcon(class, 'WeaponIconsMP', icon, 'WeaponIconsSelected', nil, nil, 12)
end

HL2HUD.scheme.Register('Entropy Zero 2', SCHEME)
