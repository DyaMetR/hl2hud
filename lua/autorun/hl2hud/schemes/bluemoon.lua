
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(150, 200, 255),
  Caution = Color(255, 0, 48),
  FgColor = Color(150, 200, 255),
  BrightFg = Color(180, 230, 255),
  BrightBg = Color(150, 200, 255, 80),
  SelectionNumberFg = Color(150, 200, 255),
  SelectionTextFg = Color(150, 200, 255),
  AuxPowerHighColor = Color(150, 200, 255, 220),
  SquadMemberAdded = Color(150, 200, 255),
  SquadMember = Color(150, 200, 255, 160),
  ZoomReticleColor = Color(150, 200, 255)
})

SCHEME:Font('HudNumbers', 'AlphavilleLight', 32, 0, true)
SCHEME:Font('HudNumbersGlow', 'AlphavilleLight', 32, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'AlphavilleLight', 16, 1000, true)
SCHEME:Font('HudHintTextSmall', 'AlphavilleLight', 9, 1000, true)
SCHEME:Font('HudHintText', 'AlphavilleLight', 10, 0, true)
SCHEME:Font('HudHintTextLarge', 'AlphavilleLight', 14, 1000, true)
SCHEME:Font('HudSelectionNumbers', 'AlphavilleLight', 11, 700, true)
SCHEME:Font('HudSelectionText', 'Verdana', 7, 1000, true)

SCHEME:Layout({
  HudHealth = {
  	xpos = 16,
  	ypos = 12,
  	wide = 60,
  	tall = 44,
  	halign = 1,
  	valign = 2,
  	digit_xpos = 7,
  	digit_ypos = 10,
  	text_xpos = 8,
  	text_ypos = 4
  },
  HudSuit = {
  	xpos = 16,
  	ypos = 58,
  	wide = 60,
  	tall = 44,
  	halign = 1,
  	valign = 2,
  	digit_xpos = 7,
  	digit_ypos = 10,
  	text_xpos = 8,
  	text_ypos = 4
  },
  HudAmmo = {
  	xpos = 16,
  	ypos = 12,
  	wide = 61,
  	tall = 56,
  	halign = 2,
  	valign = 2,
  	digit_xpos = 7,
  	digit_ypos = 10,
  	digit2_xpos = 8,
  	digit2_ypos = 39,
  	text_xpos = 8,
  	text_ypos = 4
  },
  HudAmmoSecondary = {
  	xpos = 16,
  	ypos = 72,
  	wide = 61,
  	tall = 44,
  	halign = 2,
  	valign = 2,
  	digit_xpos = 7,
  	digit_ypos = 10,
  	text_xpos = 8,
  	text_ypos = 4
  },
  HudSuitPower = {
    xpos = 78,
    ypos = 12
  },
  HudAccount = {
    xpos = 79,
    ypos = 12,
    wide = 92,
    tall = 44,
    digit_xpos = 7,
    digit_ypos = 10,
    text_ypos = 4,
    digit2_xpos = 50,
    digit2_ypos = 0,
    text2_xpos = 42,
    text2_ypos = 0
  },
  HudHistoryResource = {
    tall = 272
  },
  HudPoisonDamageIndicator = {
    ypos = 59
  },
  HudSquadStatus = {
    xpos = 370,
    ypos = 12,
    wide = 100,
    tall = 32,
    halign = 1,
    text = '',
    IconInsetX = 8,
    IconInsetY = -4,
    IconGap = 24
  },
  HudFlashlight = {
    xpos = 182
  }
})

SCHEME:Animations({
  OpenWeaponSelectionMenu = {
    { 'StopEvent', 'CloseWeaponSelectionMenu', 0 },
    { 'RunEvent', 'FadeOutWeaponSelectionMenu', 0 },
    { 'Animate', 'HudWeaponSelection', 'Alpha', 128, 'Linear', 0, .1 },
    { 'Animate', 'HudWeaponSelection', 'SelectionAlpha', 255, 'Linear', 0, .1 }
  },
  SuitPowerIncreased = {
    { 'StopEvent', 'SuitPowerZero', 0 },
    { 'StopEvent', 'SuitPulse', 0 },
    { 'Animate', 'HudSuit', 'Alpha', 255, 'Linear', 0, 0 },
    { 'Animate', 'HudSuit', 'BgColor', 'BgColor', 'Linear', 0, 0 },
    { 'Animate', 'HudSuit', 'FgColor', 'FgColor', 'Linear', 0, .05 },
    { 'Animate', 'HudSuit', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'Blur', 0, 'Deaccel', .1, 2 },
    { 'Animate', 'HudPoisonDamageIndicator', 'Position', Vector(0, 45), 'Deaccel', 0, .4 }
  },
  SuitPowerZero = {
    { 'StopEvent', 'SuitDamageTaken', 0 },
    { 'Animate', 'HudSuit', 'Alpha', 0, 'Linear', 0, .4 },
    { 'Animate', 'HudPoisonDamageIndicator', 'Position', Vector(0, 0), 'Deaccel', 0, .4 }
  },
  WeaponUsesClips = {
    { 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
  },
	WeaponDoesNotUseClips = {
    { 'Animate', 'HudAmmo', 'Size', Vector(0, -12), 'Deaccel', 0, .4 }
  },
  WeaponDoesNotUseSecondaryAmmo = {
    { 'StopPanelAnimations', 'HudAmmoSecondary', 0 },
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 0, 'Linear', 0, .1 }
  },
  WeaponUsesSecondaryAmmo = {
    { 'StopPanelAnimations', 'HudAmmoSecondary', 0 },
    { 'Animate', 'HudAmmoSecondary', 'BgColor', 'BrightBg', 'Linear', 0, .1 },
    { 'Animate', 'HudAmmoSecondary', 'BgColor', 'BgColor', 'Deaccel', .1, 1 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .1 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Linear', .2, 1.5 },
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 255, 'Linear', 0, .1 }
  }
})

HL2HUD.scheme.Register('Blue Moon', SCHEME)
