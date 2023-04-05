
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(64, 128, 255),
  Caution = Color(255, 0, 0),
  FgColor = Color(66, 123, 255, 180),
  BrightFg = Color(66, 123, 255),
  BgColor = Color(0, 0, 0, 0),
  BrightBg = Color(0, 0, 0, 0),
  DamagedBg = Color(0, 0, 0, 0),
  BrightDamagedBg = Color(0, 0, 0, 0),
  SelectionNumberFg = Color(66, 123, 255),
  SelectionTextFg = Color(0, 0, 0, 0),
  SelectionEmptyBoxBg = Color(24, 36, 64, 124),
  SelectionBoxBg = Color(24, 36, 64, 124),
  SelectionSelectedBoxBg = Color(24, 36, 64, 124),
  AuxPowerHighColor = Color(66, 123, 255, 220),
  SquadMemberAdded = Color(66, 123, 255),
  SquadMember = Color(66, 123, 255, 220),
  ZoomReticleColor = Color(64, 128, 255)
})

SCHEME:Font('HudNumbers', 'Futured', 24, 1000, true)
SCHEME:Font('HudNumbersGlow', 'Futured', 24, 1000, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'Futured', 10, 1000, true)
SCHEME:Font('HudSelectionNumbers', 'Futured', 9, 1000, true)
SCHEME:Font('HudIcons', 'Counter-Strike', 32, 0, true)

SCHEME:Layout({
  HudHealth = {
    digit_xpos = 30,
    digit_ypos = 7,
    text_xpos = 7,
    text_ypos = 0,
    text = 'b',
    text_font = 'HudIcons'
  },
  HudSuit = {
    digit_xpos = 30,
    digit_ypos = 7,
    text_xpos = 7,
    text_ypos = 0,
    text = 'l',
    text_font = 'HudIcons'
  },
  HudAmmo = {
    wide = 114,
    digit_xpos = 42,
    digit_ypos = 7,
    digit2_xpos = 81,
    digit2_ypos = 15,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 24,
    icon_ypos = 18
  },
  HudAmmoSecondary = {
    digit_xpos = 34,
    digit_ypos = 7,
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
    BarChunkGap = 0,
  },
  HudWeaponSelection = {
    compact = false,
    LargeBoxTall = 64,
    SelectionNumberXPos = 8,
    SelectionNumberYPos = 3,
    SkipEmpty = true
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
	}
})

HL2HUD.scheme.Register('Insecurity', SCHEME)
