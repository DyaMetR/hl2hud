
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(135, 145, 75),
  Caution = Color(120, 130, 60),
  FgColor = Color(26, 26, 16),
  BrightFg = Color(26, 26, 16),
  BgColor = Color(135, 145, 75),
  SelectionNumberFg = Color(26, 26, 16),
  SelectionTextFg = Color(26, 26, 16),
  SelectionEmptyBoxBg = Color(135, 145, 75),
  SelectionBoxBg = Color(135, 145, 75),
  SelectionSelectedBoxBg = Color(135, 145, 75),
  AuxPowerHighColor = Color(26, 26, 16),
  SquadMemberAdded = Color(120, 130, 60),
  SquadMember = Color(26, 26, 16),
  SquadMemberLeft = Color(0, 0, 0),
  SquadMemberDying = Color(120, 130, 60),
  SquadMemberDied = Color(0, 0, 0),
  ZoomReticleColor = Color(135, 145, 75),
  Crosshair = Color(255, 255, 255),
  Blank = Color(0, 0, 0, 0),
  Disabled = Color(120, 130, 60)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 56, 0)
SCHEME:Font('WeaponIconsSelected', 'HalfLife2', 56, 0, false, 5)
SCHEME:Font('WeaponIconsSmall', 'HalfLife2', 32, 0)
SCHEME:Font('Crosshairs', 'HalfLife2', 40, 0, false, nil, nil, nil, false, false)
SCHEME:Font('QuickInfo', 'HL2cross', 28, 0)
SCHEME:Font('HudNumbers', 'Typo Digit Demo', 36, 0, false, nil, nil, nil, true, false)
SCHEME:Font('HudNumbersMed', 'Typo Digit Demo', 24, 0, false, nil, nil, nil, true, false)
SCHEME:Font('HudNumbersSmall', 'DS-Digital', 16, 1000)
SCHEME:Font('HudHintTextSmall', 'Tahoma', 7, 1000)
SCHEME:Font('HudHintText', 'Verdana', 10, 0)
SCHEME:Font('HudHintTextLarge', 'Verdana', 14, 1000)
SCHEME:Font('HudSelectionNumbers', 'Verdana', 11, 700)
SCHEME:Font('HudSelectionText', 'Verdana', 7, 1000)
SCHEME:Font('SquadIcon', 'HalfLife2', 32, 0)
SCHEME:Font('HudIcons', 'Webdings', 16, 0, false, nil, nil, true)

SCHEME:Layout({
  HudHealth = {
    wide = 74,
    digit_xpos = 68,
    digit_ypos = 0,
    digit_align = 2,
    text_xpos = 4,
    text_ypos = 2,
    text = 'Y',
    text_font = 'HudIcons'
  },
  HudSuit = {
    xpos = 16,
    wide = 104,
    digit_xpos = 100,
    digit_ypos = 2,
    digit_align = 2,
    digit_font = 'HudNumbersMed',
    text_xpos = 4,
    text_ypos = 17,
    text = 'd',
    text_font = 'HudIcons'
  },
  HudAmmo = {
    wide = 82,
    digit_xpos = 76,
    digit_ypos = 0,
    digit_align = 2,
    digit2_xpos = 31,
    digit2_ypos = 17,
    digit2_align = 2,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 19,
    icon_ypos = 10
  },
  HudAmmoSecondary = {
    wide = 42,
    digit_xpos = 36,
    digit_ypos = 17,
    digit_align = 2,
    digit_font = 'HudNumbersSmall',
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 21,
    icon_ypos = 10
  },
  HudSuitPower = {
    wide = 104,
    tall = 16,
    text = '',
    text2_ypos = 24,
    BarInsetX = 6,
    BarInsetY = 6
  },
  HudPoisonDamageIndicator = {
    xpos = 16,
    ypos = 12,
    wide = 104,
    tall = 36,
    text = 'POISON',
    text_xpos = 78,
    text_ypos = 25
  },
  HudSquadStatus = {
    wide = 72,
    tall = 38,
    text_xpos = 6,
    text_ypos = 27,
    IconInsetX = 5,
    IconInsetY = -2,
    IconGap = 17
  },
  HudWeaponSelection = {},
  HudCrosshair = {
    color = 'Crosshair'
  }
})

SCHEME:Animations({
  Init = {
    { 'Animate', 'HudHealth', 'BgColor', 'Blank', 'Linear', 0, 0 },
    { 'Animate', 'HudSuit', 'BgColor', 'Blank', 'Linear', 0, 0 },
    { 'Animate', 'HudPoisonDamageIndicator', 'BgColor', 'BgColor', 'Linear', 0, 0 },
    { 'Animate', 'HudPoisonDamageIndicator', 'FgColor', 'Disabled', 'Linear', 0, 0 },
    { 'Animate', 'HudPoisonDamageIndicator', 'Alpha', 255, 'Linear', 0, 0 }
  },
  OpenWeaponSelectionMenu = {
    { 'StopEvent', 'CloseWeaponSelectionMenu', 0 },
    { 'RunEvent', 'FadeOutWeaponSelectionMenu', 0 },
    { 'Animate', 'HudWeaponSelection', 'Alpha', 255, 'Linear', 0, .1 },
    { 'Animate', 'HudWeaponSelection', 'SelectionAlpha', 255, 'Linear', 0, .1 }
  },
  HealthIncreased = {
    { 'StopEvent', 'HealthPulse', 0 },
    { 'StopEvent', 'HealthLoop', 0 },
    { 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Linear', 0, .1 }
  },
  HealthDamageTaken = {},
  HealthPulse = {
    { 'Animate', 'HudHealth', 'FgColor', 'Disabled', 'Linear', 0, .1 },
    { 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Deaccel', .1, .8 },
    { 'RunEvent', 'HealthLoop', 1 }
  },
  HealthLow = {
    { 'StopEvent', 'HealthPulse', 0 },
    { 'StopEvent', 'HealthLoop', 0 },
    { 'RunEvent', 'HealthPulse', 0 }
  },
  HealthLoop = {
    { 'RunEvent', 'HealthPulse', 0 }
  },
  SuitPowerIncreased = {
    { 'Animate', 'HudSuit', 'FgColor', 'FgColor', 'Linear', 0, .4 }
  },
  SuitDamageTaken = {},
  SuitPowerZero = {
    { 'Animate', 'HudSuit', 'FgColor', 'Disabled', 'Linear', 0, .4 }
  },
  AmmoIncreased = {
    { 'Animate', 'HudAmmo', 'FgColor', 'FgColor', 'Linear', 0, .4 }
  },
  AmmoDecreased = {},
  AmmoEmpty = {
    { 'Animate', 'HudAmmo', 'FgColor', 'Disabled', 'Linear', 0, .4 }
  },
  AmmoSecondaryIncreased = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Linear', 0, .4 }
  },
  AmmoSecondaryDecreased = {},
  AmmoSecondaryEmpty = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'Disabled', 'Linear', 0, .4 }
  },
  WeaponChanged = {},
  WeaponUsesClips = {},
  WeaponDoesNotUseClips = {},
  WeaponDoesNotUseSecondaryAmmo = {
    { 'StopPanelAnimations', 'HudAmmoSecondary', 0 },
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 0, 'Linear', 0, .1 },
    { 'Animate', 'HudAmmo', 'Position', Vector(0, 0), 'Deaccel', 0, .4 }
  },
  WeaponUsesSecondaryAmmo = {
    { 'StopPanelAnimations', 'HudAmmoSecondary', 0 },
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 255, 'Linear', 0, .1 },
    { 'Animate', 'HudAmmo', 'Position', Vector(40, 0), 'Deaccel', 0, .4 }
  },
  SuitAuxPowerDecreasedBelow25 = {},
  SuitAuxPowerNoItemsActive = {},
  SuitAuxPowerOneItemActive = {},
  SuitAuxPowerTwoItemsActive = {},
  SuitAuxPowerThreeItemsActive = {},
  PoisonDamageTaken = {
    { 'RunEvent', 'PoisonPulse', 0 }
  },
  PoisonDamageCured = {
    { 'StopEvent', 'PoisonDamageTaken', 0 },
    { 'StopEvent', 'PoisonLoop', 0 },
    { 'StopEvent', 'PoisonPulse', 0 },
    { 'Animate', 'HudPoisonDamageIndicator', 'FgColor', 'Disabled', 'Linear', 0, 1 }
  },
  PoisonPulse = {
    { 'Animate', 'HudPoisonDamageIndicator', 'FgColor', 'FgColor', 'Linear', 0, .1 },
    { 'Animate', 'HudPoisonDamageIndicator', 'FgColor', 'Disabled', 'Deaccel', .1, .8 },
    { 'RunEvent', 'PoisonLoop', 1 }
  },
  PoisonLoop = {
    { 'RunEvent', 'PoisonPulse', 0 }
  }
})

HL2HUD.scheme.Register('LCD', SCHEME)
