
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(64, 232, 64),
  Caution = Color(255, 48, 0),
  FgColor = Color(32, 255, 32, 100),
  BrightFg = Color(32, 255, 32),
  DamagedFg = Color(255, 32, 32),
  BgColor = Color(0, 0, 0, 0),
  BrightBg = Color(0, 0, 0, 0),
  DamagedBg = Color(0, 0, 0, 0),
  BrightDamagedBg = Color(0, 0, 0, 0),
  SelectionNumberFg = Color(32, 255, 32),
  SelectionTextFg = Color(32, 255, 32),
  AuxPowerHighColor = Color(32, 255, 32, 220),
  SquadMemberAdded = Color(32, 255, 32),
  SquadMember = Color(32, 255, 32, 160),
  ZoomReticleColor = Color(48, 255, 48)
})

SCHEME:Font('HudNumbers', 'Transponder AOE', 32, 0, true)
SCHEME:Font('HudNumbersGlow', 'Transponder AOE', 32, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'Transponder AOE', 16, 0, true)
SCHEME:Font('HudHintTextSmall', 'Cogan-Light', 11, 1000)
SCHEME:Font('HudHintText', 'Cogan-Light', 10, 0, true)
SCHEME:Font('HudHintTextLarge', 'Cogan-Light', 14, 0, true)
SCHEME:Font('HudSelectionNumbers', 'Transponder AOE', 11, 700)
SCHEME:Font('HudSelectionText', 'Cogan-Light', 11, 1000)

SCHEME:Layout({
  HudHealth = {
    wide = 56,
    tall = 44,
    digit_xpos = 8,
    digit_ypos = -2,
    text_xpos = 8,
    text_ypos = 30,
    text = 'VITALS'
  },
  HudSuit = {
    xpos = 81,
    wide = 56,
    tall = 44,
    digit_xpos = 8,
    digit_ypos = -2,
    text_xpos = 8,
    text_ypos = 30,
    text = 'PCV'
  },
  HudAmmo = {
    wide = 78,
    tall = 44,
    digit_xpos = 46,
    digit_ypos = -2,
    digit_align = 2,
    digit2_xpos = 50,
    digit2_ypos = 2,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 34,
    icon_ypos = 34
  },
  HudAmmoSecondary = {
    wide = 62,
    tall = 44,
    digit_xpos = 8,
    digit_ypos = -2,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 20,
    icon_ypos = 34
  },
  HudSuitPower = {
    ypos = 56,
    wide = 126,
    tall = 24,
    text_ypos = 10,
    text2_ypos = 24,
    BarInsetY = 3,
    BarChunkWidth = 1,
    BarChunkGap = 2,
    BarHeight = 7
  },
  HudAccount = {
    wide = 84,
    tall = 44,
    digit_xpos = 74,
    digit_ypos = -2,
    digit_align = 2,
    text_xpos = 50,
    text_ypos = 30,
    text = 'FUNDS',
    digit2_xpos = 15,
    digit2_ypos = 26,
    text2_xpos = 6,
    text2_ypos = 28
  },
  HudSquadStatus = {
    ypos = 62,
    text_ypos = 32
  },
  HudFlashlight = {
    xpos = 146,
    BarChunkWidth = 1,
    BarChunkGap = 1
  }
})

SCHEME:Animations({
  SuitAuxPowerNoItemsActive = {},
  SuitAuxPowerOneItemActive = {},
  SuitAuxPowerTwoItemsActive = {},
  SuitAuxPowerThreeItemsActive = {},
  WeaponDoesNotUseClips = {
		{ 'Animate', 'HudAmmo', 'Position', Vector(0, 0), 'Deaccel', 0, .4 }
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
		{ 'Animate', 'HudAmmo', 'Position', Vector(62, 0), 'Deaccel', 0, .5 },
		{ 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
	}
})

HL2HUD.scheme.Register('Nightvision', SCHEME)
