
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  FgColor = Color(247, 125, 30, 220),
  BgColor = Color(0, 0, 0, 0),
  BrightFg = Color(247, 125, 30, 220),
  BrightBg = Color(0, 0, 0, 0),
  DamagedFg = Color(255, 0, 0, 200),
  SelectionNumberFg = Color(0, 0, 0, 0),
  SelectionTextFg = Color(0, 0, 0, 0),
  SelectionEmptyBoxBg = Color(0, 0, 0, 0),
  SelectionBoxBg = Color(0, 0, 0, 0),
  SelectionSelectedBoxBg = Color(23, 12, 11, 141),
  Normal = Color(247, 125, 30, 220),
  Caution = Color(255, 48, 0, 255),
  ZoomReticleColor = Color(255, 255, 255)
})

SCHEME:Font('Crosshairs', 'GarbageFont1', 40, 0, true, nil, nil, nil, false, false)
SCHEME:Font('QuickInfo', 'GarbageFont', 28, 0, true)
SCHEME:Font('HudNumbers', 'eLePhAnT uNcLe', 32, 0, true)
SCHEME:Font('HudNumbersGlow', 'eLePhAnT uNcLe', 32, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'eLePhAnT uNcLe', 16, 1000, true)
SCHEME:Font('HudHintTextSmall', 'GarbageFont', 9, 1000)
SCHEME:Font('HudHintText', 'GarbageFont', 10, 0, true)
SCHEME:Font('HudHintTextLarge', 'GarbageFont', 14, 1000, true)
SCHEME:Font('HudSelectionNumbers', 'eLePhAnT uNcLe', 11, 700)
SCHEME:Font('HudSelectionText', 'GarbageFont', 7, 1000)

SCHEME:Layout({
  HudHealth = {
    xpos = 21,
    ypos = 4,
    wide = 78,
    tall = 38,
    valign = 1,
    text = '',
    digit_xpos = 5,
    digit_ypos = 5
  },
  HudSuit = {
    xpos = 77,
    ypos = 20,
    wide = 78,
    tall = 38,
    valign = 1,
    digit_font = 'HudNumbersSmall',
    text = '',
    digit_xpos = 5,
    digit_ypos = 5
  },
  HudAmmo = {
    ypos = 4,
    wide = 136,
    tall = 38,
    valign = 1,
    text = '',
    digit_xpos = 44,
    digit_ypos = 2,
    digit2_xpos = 98,
    digit2_ypos = 16
  },
  HudAmmoSecondary = {
    ypos = 4,
    wide = 60,
    tall = 38,
    valign = 1,
    text = '',
    digit_xpos = 10,
    digit_ypos = 2
  },
  HudWeaponSelection = {
    compact = false,
    ypos = 10,
    LargeBoxWide = 97,
    LargeBoxTall = 39,
    SkipEmpty = true,
    MoveSnd = 'hl2hud/gstringbeta/wpn_moveselect.wav',
    SelectSnd = 'hl2hud/gstringbeta/wpn_select.wav'
  },
  HUDQuickInfo = {
    visible = true,
    left_bracket = '',
    left_bracket_empty = '',
    right_bracket = '',
    right_bracket_empty = '',
    warning_sound = 'hl2hud/gstringbeta/warning.wav'
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
    { 'Animate', 'HudHealth', 'FgColor', 'DamagedFg', 'Linear', 0, 0 }
  },
  SuitPowerIncreased = {
    { 'Animate', 'HudSuit', 'Alpha', 255, 'Linear', 0, 0 }
  },
  SuitArmorLow = {},
  SuitDamageTaken = {},
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
    { 'Animate', 'HudAmmo', 'Position', Vector(72, 0), 'Deaccel', 0, .5 },
    { 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
  },
  WeaponDoesNotUseSecondaryAmmo = {
    { 'StopPanelAnimations', 'HudAmmoSecondary', 0 },
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 0, 'Linear', 0, .1 }
  },
  SuitAuxPowerNotMax = {},
  SquadStatusShow = {}
})

for weapon, _ in pairs(HL2HUD.scheme.GetDefault().HudTextures.Selected) do
  SCHEME:RemoveSelectedWeaponIcon(weapon)
end

HL2HUD.scheme.Register('G String Beta', SCHEME)
