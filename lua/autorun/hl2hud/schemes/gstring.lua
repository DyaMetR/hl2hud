
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  FgColor = Color(255, 255, 255, 100),
  BgColor = Color(0, 0, 0, 120),
  BrightBg = Color(255, 255, 255, 80),
  BrightFg = Color(210, 210, 210, 210),
  DamagedBg = Color(180, 0, 0, 200),
  DamagedFg = Color(180, 0, 0, 230),
  BrightDamagedFg = Color(255, 0, 0),
  SelectionNumberFg = Color(255, 255, 255),
  SelectionTextFg = Color(255, 255, 255),
  SelectionEmptyBoxBg = Color(0, 0, 0, 0),
  SelectionBoxBg = Color(0, 0, 0, 220),
  SelectionSelectedBoxBg = Color(0, 0, 0, 200),
  Normal = Color(255, 255, 255),
  Caution = Color(255, 48, 0)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 46, 0, true)
SCHEME:Font('HudNumbers', 'Birdman', 25, 122, true, 0, 2)
SCHEME:Font('HudNumbersGlow', 'Birdman', 25, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'Birdman', 16, 1000, true, 0, 2)
SCHEME:Font('HudSelectionNumbers', 'Birdman', 9, 1000, true, 0, 2)
SCHEME:Font('HudHintTextSmall', 'Birdman', 11, 211, true)
SCHEME:Font('HudSelectionText', 'whitrabt', 5)

SCHEME:Layout({
  HudHealth = {
    xpos = 25,
    ypos = 15,
    wide = 60,
    tall = 34,
    valign = 1,
    text_xpos = 10,
    text_ypos = 22,
    digit_xpos = 12,
    digit_ypos = 1
  },
  HudSuit = {
    xpos = 108,
    ypos = 15,
    wide = 60,
    tall = 34,
    valign = 1,
    text_xpos = 19,
    text_ypos = 22,
    digit_xpos = 12,
    digit_ypos = 1
  },
  HudAmmo = {
    xpos = 22,
    ypos = 15,
    wide = 120,
    tall = 34,
    valign = 1,
    text_xpos = 8,
    text_ypos = 22,
    digit_xpos = 46,
    digit_ypos = 1,
    digit2_xpos = 85,
    digit2_ypos = 5
  },
  HudAmmoSecondary = {
    xpos = 22,
    ypos = 15,
    wide = 60,
    tall = 34,
    valign = 1,
    text_xpos = 40,
    text_ypos = 32,
    digit_xpos = 8,
    digit_ypos = 1
  },
  HudFlashlight = {
    xpos = 22,
    ypos = 56,
    wide = 30,
    tall = 17,
    valign = 1,
    halign = 2,
    icon_xpos = 16,
    icon_ypos = -6,
    BarInsetY = 148
  },
  HudZoom = {
    Circle1Radius = 0,
    Circle2Radius = 0,
    DashHeight = 0
  },
  HudWeaponSelection = {
    compact = false,
    ypos = 15,
    SmallBoxSize = 21,
    LargeBoxWide = 89,
    LargeBoxTall = 41,
    BoxGap = 18,
    SelectionNumberXPos = 10,
    SelectionNumberYPos = 5,
    TextYPos = 34,
    SkipEmpty = true,
    MoveSnd = 'hl2hud/gstring/wpn_moveselect.wav',
    SelectSnd = 'hl2hud/gstring/wpn_select.wav'
  },
  HUDQuickInfo = {
    warning_sound = 'hl2hud/gstring/warning.wav'
  }
})

SCHEME:Animations({
  HealthIncreased = {
    { 'StopEvent', 'HealthLoop', 0 },
    { 'StopEvent', 'HealthPulse', 0 },
    { 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Linear', 0, 0 },
    { 'StopEvent', 'HealthLow', 0 }
  },
  HealthDamageTaken = {},
  HealthLow = {
    { 'StopEvent', 'HealthDamageTaken', 0 },
    { 'StopEvent', 'HealthPulse', 0 },
    { 'StopEvent', 'HealthLoop', 0 },
    { 'RunEvent', 'HealthPulse', 1 }
  },
  HealthPulse = {
    { 'Animate', 'HudHealth', 'FgColor', 'DamagedFg', 'Linear', 0, 0 },
    { 'RunEvent', 'HealthPulse', .8 }
  },
  SuitArmorLow = {},
  AmmoIncreased = {
		{ 'Animate', 'HudAmmo', 'FgColor', 'BrightFg', 'Linear', 0, .15 },
		{ 'Animate', 'HudAmmo', 'FgColor', 'FgColor', 'Deaccel', .15, 1.5 }
	},
  AmmoDecreased = {
    { 'StopEvent', 'AmmoIncreased', 0 }
	},
  AmmoSecondaryIncreased = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .15 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Deaccel', .15, 1.5 }
  },
  AmmoSecondaryDecreased = {
    { 'StopEvent', 'AmmoSecondaryIncreased', 0 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .1 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Deaccel', .1, .75 }
  },
  AmmoSecondaryEmpty = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightDamagedFg', 'Linear', 0, .2 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'DamagedFg', 'Accel', 0.2, 1.2 }
  },
  WeaponUsesClips = {
		{ 'Animate', 'HudAmmo', 'Position', Vector(0, 0), 'Deaccel', 0, .4 },
		{ 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
	},
	WeaponDoesNotUseClips = {
		{ 'Animate', 'HudAmmo', 'Position', Vector(0, 0), 'Deaccel', 0, .4 },
		{ 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
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
		{ 'Animate', 'HudAmmo', 'Position', Vector(108, 0), 'Deaccel', 0, .5 },
		{ 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
	},
  WeaponDoesNotUseSecondaryAmmo = {
    { 'StopPanelAnimations', 'HudAmmoSecondary', 0 },
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 0, 'Linear', 0, .1 }
  },
  SuitAuxPowerNotMax = {}
})

for weapon, _ in pairs(HL2HUD.scheme.GetDefault().HudTextures.Selected) do
  SCHEME:RemoveSelectedWeaponIcon(weapon)
end

HL2HUD.scheme.Register('G String', SCHEME)
