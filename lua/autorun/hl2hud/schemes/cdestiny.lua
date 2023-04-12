
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(0, 88, 207),
  Caution = Color(0, 67, 104),
  FgColor = Color(0, 88, 207, 100),
  BrightFg = Color(0, 88, 207),
  DamagedFg = Color(0, 88, 207, 230),
  BrightDamagedFg = Color(0, 88, 207),
  BrightBg = Color(0, 88, 207, 80),
  DamagedBg = Color(0, 88, 207, 80),
  BrightDamagedBg = Color(0, 88, 207, 200),
  SelectionNumberFg = Color(0, 88, 207),
  SelectionTextFg = Color(0, 88, 207),
  AuxPowerHighColor = Color(0, 88, 207, 220),
  SquadMemberAdded = Color(0, 88, 207),
  SquadMember = Color(0, 88, 207, 160),
  ZoomReticleColor = Color(0, 88, 207)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 62, 0, true)
SCHEME:Font('WeaponIconsSelected', 'HalfLife2', 62, 0, true, 5, 2)
SCHEME:Font('HudNumbers', 'EmpireBuilder', 28, 0, true)
SCHEME:Font('HudNumbersGlow', 'EmpireBuilder', 28, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'EmpireBuilder', 12, 0, true)

SCHEME:Layout({
  HudAmmo = {
    digit_xpos = 44
  },
  HudAmmoSecondary = {
    wide = 60
  },
  HudWeaponSelection = {
    compact = false,
    uppercase = true,
    TextYPos = 64,
    TextAlign = 1,
    SkipEmpty = true
  },
  HudHistoryResource = {
    ShowMissingIcons = false
  },
  HudDamageIndicator = {
    visible = true
  }
})

SCHEME:Sequence('WeaponUsesSecondaryAmmo', {
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
})

HL2HUD.scheme.Register('Combine Destiny', SCHEME)
