
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(32, 255, 32),
  Caution = Color(255, 0, 0),
  FgColor = Color(32, 255, 32, 180),
  BrightFg = Color(32, 255, 32),
  BgColor = Color(0, 0, 0, 0),
  BrightBg = Color(0, 0, 0, 0),
  DamagedBg = Color(0, 0, 0, 0),
  BrightDamagedBg = Color(0, 0, 0, 0),
  SelectionNumberFg = Color(32, 255, 32),
  SelectionTextFg = Color(0, 0, 0, 0),
  SelectionEmptyBoxBg = Color(0, 64, 0, 124),
  SelectionBoxBg = Color(0, 64, 0, 124),
  SelectionSelectedBoxBg = Color(0, 64, 0, 124),
  AuxPowerHighColor = Color(32, 255, 32, 220),
  SquadMemberAdded = Color(32, 255, 32),
  SquadMember = Color(32, 255, 32),
  ZoomReticleColor = Color(32, 255, 32)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 56, 0, true, 0, 1)
SCHEME:Font('WeaponIconsSmall', 'HalfLife2', 32, 0, true, 0, 1)
SCHEME:Font('HudNumbers', 'AlphavilleLight', 30, 1000, true, 0, 1)
SCHEME:Font('HudNumbersGlow', 'AlphavilleLight', 30, 1000, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'AlphavilleLight', 14, 1000, true, 0, 1)
SCHEME:Font('HudSelectionNumbers', 'AlphavilleLight', 10, 1000)
SCHEME:Font('HudIcons', 'Counter-Strike', 32, 0, true, 0, 1)

SCHEME:Layout({
  HudHealth = {
    digit_xpos = 28,
    digit_ypos = 4,
    text_xpos = 7,
    text_ypos = 0,
    text = 'b',
    text_font = 'HudIcons'
  },
  HudSuit = {
    digit_xpos = 28,
    digit_ypos = 4,
    text_xpos = 7,
    text_ypos = 0,
    text = 'a',
    text_font = 'HudIcons'
  },
  HudAmmo = {
    wide = 114,
    digit_xpos = 40,
    digit_ypos = 4,
    digit2_xpos = 81,
    digit2_ypos = 11,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 24,
    icon_ypos = 18
  },
  HudAmmoSecondary = {
    digit_xpos = 32,
    digit_ypos = 4,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 18,
    icon_ypos = 18
  },
  HudSuitPower = {
    ypos = 44,
    tall = 16,
    text = '',
    text2_ypos = 24,
    BarInsetY = 6,
    BarChunkWidth = 1,
    BarChunkGap = 2,
  },
  HudAccount = {
    wide = 108,
    tall = 48,
    digit_xpos = 28,
    digit_ypos = 16,
    text_ypos = 16,
    text_font = 'HudNumbers',
    text = '$',
    digit2_xpos = 28,
    digit2_ypos = 3,
    text2_xpos = 16,
    text2_ypos = 2
  },
  HudWeaponSelection = {
    compact = false,
    LargeBoxTall = 64,
    SelectionNumberXPos = 8,
    SelectionNumberYPos = 3
  },
  HudFlashlight = {
    xpos = 12,
    ypos = 8,
    halign = 2,
    valign = 1,
    BarChunkWidth = 1,
    BarChunkGap = 1,
    BarWidth = 26
  }
})

SCHEME:Animations({
  SuitPowerZero = {
    { 'Animate', 'HudSuit', 'Alpha', 128, 'Linear', 0, .4 }
  },
  SuitAuxPowerNoItemsActive = {},
  SuitAuxPowerOneItemActive = {},
  SuitAuxPowerTwoItemsActive = {},
  SuitAuxPowerThreeItemsActive = {},
  WeaponDoesNotUseClips = {
		{ 'Animate', 'HudAmmo', 'Position', Vector(0, 0), 'Deaccel', 0, .4 },
		{ 'Animate', 'HudAmmo', 'Size', Vector(-26, 0), 'Deaccel', 0, .4 }
	},
  SquadStatusShow = {
    { 'StopEvent', 'SquadStatusHide', 0 },
    { 'Animate', 'HudSquadStatus', 'Alpha', 255, 'Linear', 0, .3 },
    { 'Animate', 'HudAccount', 'Position', Vector(0, 48), 'Deaccel', 0, .5 }
  }
})

HL2HUD.scheme.Register('Military Precision', SCHEME)
