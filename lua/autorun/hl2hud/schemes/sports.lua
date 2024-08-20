
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(255, 255, 255),
  Caution = Color(255, 0, 0),
  FgColor = Color(255, 255, 255, 100),
  BrightFg = Color(255, 255, 255),
  BrightBg = Color(250, 255, 255, 80),
  SelectionNumberFg = Color(255, 255, 255),
  SelectionTextFg = Color(255, 255, 255, 100),
  AuxPowerHighColor = Color(255, 255, 255, 220),
  SquadMemberAdded = Color(255, 255, 255),
  SquadMember = Color(255, 255, 255, 160),
  ZoomReticleColor = Color(255, 255, 255)
})

SCHEME:Font('HudNumbers', 'Pricedown', 58, 0, true)
SCHEME:Font('HudNumbersGlow', 'Pricedown', 58, 0, true, 4)
SCHEME:Font('HudNumbersSmall', 'Pricedown', 24, 0, true)
SCHEME:Font('HudHintTextSmall', 'Impact', 14, 1000)
SCHEME:Font('HudHintText', 'Impact', 10, 0, true)
SCHEME:Font('HudHintTextLarge', 'Impact', 14, 1000, true)
SCHEME:Font('HudSelectionNumbers', 'Pricedown', 14, 700)
SCHEME:Font('HudSelectionText', 'Impact', 11, 1000)

SCHEME:Layout({
  HudHealth = {
    digit_xpos = 40,
    digit_ypos = -12,
    text_xpos = 4,
    text_ypos = 1
  },
  HudSuit = {
    wide = 102,
    digit_xpos = 40,
    digit_ypos = -12,
    text_xpos = 4,
    text_ypos = 1
  },
  HudAmmo = {
    wide = 142,
    digit_xpos = 40,
    digit_ypos = -12,
    digit2_xpos = 102,
    digit2_ypos = 6,
    text_xpos = 4,
    text_ypos = 1
  },
  HudAmmoSecondary = {
    digit_ypos = -12,
    text_xpos = 4,
    text_ypos = 1
  },
  HudSuitPower = {
    font = 'HudHintText',
    BarInsetY = 17,
    text2_ypos = 23
  },
  HudAccount = {
    wide = 150,
    digit_xpos = 40,
    digit_ypos = -12,
    text_xpos = 4,
    text_ypos = 1,
    digit2_xpos = 11,
    digit2_ypos = 14,
    digit2_font = 'HudHintTextSmall',
    text2_xpos = 4,
    text2_ypos = 14
  },
  HudWeaponSelection = {
    uppercase = true
  },
  HudSquadStatus = {
    text_ypos = 30
  }
})

SCHEME:Animations({
  HealthIncreased = {
    { 'StopEvent', 'HealthLoop', 0 },
    { 'StopEvent', 'HealthPulse', 0 },
    { 'StopEvent', 'HealthLow', 0 },
		{ 'Animate', 'HudHealth', 'BgColor', 'BgColor', 'Linear', 0, 0 },
		{ 'Animate', 'HudHealth', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
		{ 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Linear', .3, .75 },
		{ 'Animate', 'HudHealth', 'Blur', 3, 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', 0, 'Deaccel', .1, 2 }
	},
	HealthDamageTaken = {
		{ 'Animate', 'HudHealth', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
		{ 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Linear', .3, .75 },
		{ 'Animate', 'HudHealth', 'Blur', 3, 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', 0, 'Deaccel', .1, 2 }
	},
	HealthPulse = {
		{ 'Animate', 'HudHealth', 'FgColor', 'DamagedFg', 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', 4, 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', 1, 'Deaccel', .1, .9 },
		{ 'Animate', 'HudHealth', 'BgColor', 'DamagedBg', 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'BgColor', 'BgColor', 'Deaccel', .1, .8 },
    { 'RunEvent', 'HealthLoop', .8 }
	},
	HealthLow = {
    { 'StopEvent', 'HealthDamageTaken', 0 },
    { 'StopEvent', 'HealthPulse', 0 },
    { 'StopEvent', 'HealthLoop', 0 },
		{ 'Animate', 'HudHealth', 'BgColor', 'BrightDamagedBg', 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'BgColor', 'BgColor', 'Deaccel', .1, 1.75 },
		{ 'Animate', 'HudHealth', 'FgColor', 'BrightFg', 'Linear', 0, .2 },
		{ 'Animate', 'HudHealth', 'FgColor', 'DamagedFg', 'Linear', .2, 1.2 },
		{ 'Animate', 'HudHealth', 'Blur', 4, 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', 1, 'Deaccel', .1, .9 },
    { 'RunEvent', 'HealthPulse', 1 }
	},
  SuitPowerIncreased = {
    { 'StopEvent', 'SuitPowerZero', 0 },
    { 'StopEvent', 'SuitPulse', 0 },
    { 'Animate', 'HudSuit', 'Alpha', 255, 'Linear', 0, 0 },
    { 'Animate', 'HudSuit', 'BgColor', 'BgColor', 'Linear', 0, 0 },
    { 'Animate', 'HudSuit', 'FgColor', 'FgColor', 'Linear', 0, .05 },
    { 'Animate', 'HudSuit', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'Blur', 0, 'Deaccel', .1, 2 }
  },
  SuitDamageTaken = {
    { 'Animate', 'HudSuit', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
    { 'Animate', 'HudSuit', 'FgColor', 'FgColor', 'Linear', .3, .75 },
    { 'Animate', 'HudSuit', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'Blur', 0, 'Deaccel', .1, 2 }
  },
	AmmoIncreased = {
		{ 'Animate', 'HudAmmo', 'FgColor', 'BrightFg', 'Linear', 0, .15 },
		{ 'Animate', 'HudAmmo', 'FgColor', 'FgColor', 'Deaccel', .15, 1.5 },
		{ 'Animate', 'HudAmmo', 'Blur', 3, 'Linear', 0, 0 },
		{ 'Animate', 'HudAmmo', 'Blur', 0, 'Accel', .01, 1.5 }
	},
	AmmoDecreased = {
    { 'StopEvent', 'AmmoIncreased', 0 },
		{ 'Animate', 'HudAmmo', 'Blur', 3, 'Linear', 0, 0 },
		{ 'Animate', 'HudAmmo', 'Blur', 0, 'Deaccel', .1, 1.5 }
	},
	WeaponDoesNotUseClips = {
		{ 'Animate', 'HudAmmo', 'Position', Vector(0, 0), 'Deaccel', 0, .4 },
		{ 'Animate', 'HudAmmo', 'Size', Vector(-39, 0), 'Deaccel', 0, .4 }
	},
  AmmoSecondaryIncreased = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .15 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Deaccel', .15, 1.5 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 3, 'Linear', 0, 0 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 0, 'Accel', .01, 1.5 }
  },
  AmmoSecondaryDecreased = {
    { 'StopEvent', 'AmmoSecondaryIncreased', 0 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 3, 'Linear', 0, 0 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 0, 'Deaccel', .1, 1.5 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .1 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Deaccel', .1, .75 }
  },
  AmmoSecondaryEmpty = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightDamagedFg', 'Linear', 0, .2 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'DamagedFg', 'Accel', 0.2, 1.2 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 3, 'Linear', 0, 0 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 0, 'Deaccel', .1, 1.5 }
  }
})

HL2HUD.scheme.Register('Sports Club', SCHEME)
