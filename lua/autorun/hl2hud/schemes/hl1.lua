
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(255, 180, 32),
  Caution = Color(255, 0, 0),
  FgColor = Color(255, 160, 0, 180),
  BrightFg = Color(255, 160, 0),
  BgColor = Color(0, 0, 0, 0),
  BrightBg = Color(0, 0, 0, 0),
  DamagedBg = Color(0, 0, 0, 0),
  BrightDamagedBg = Color(0, 0, 0, 0),
  SelectionNumberFg = Color(255, 200, 0),
  SelectionTextFg = Color(0, 0, 0, 0),
  SelectionEmptyBoxBg = Color(64, 48, 0, 124),
  SelectionBoxBg = Color(64, 48, 0, 124),
  SelectionSelectedBoxBg = Color(64, 48, 0, 124),
  AuxPowerHighColor = Color(255, 200, 0, 220),
  SquadMemberAdded = Color(255, 200, 0),
  SquadMember = Color(255, 160, 0),
  ZoomReticleColor = Color(255, 180, 0),
  WeaponSelectionColor = Color(255, 200, 0)
})

SCHEME:Font('HudNumbers', 'Bahnschrift Light', 32, 1000, true)
SCHEME:Font('HudNumbersGlow', 'Bahnschrift Light', 32, 1000, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'Bahnschrift Light', 16, 1000, true)
SCHEME:Font('HudSelectionNumbers', 'Bahnschrift Light', 11, 1000)
SCHEME:Font('Cross', 'Impact', 36, 1000, true)
SCHEME:Font('HudIcons', 'HalfLife2', 42, 0, true)

SCHEME:Layout({
  HudHealth = {
    digit_xpos = 28,
    text_ypos = 2,
    text = '+',
    text_font = 'Cross'
  },
  HudSuit = {
    digit_xpos = 28,
    text_xpos = 13,
    text_ypos = -8,
    text = 'C',
    text_font = 'HudIcons'
  },
  HudAmmo = {
    wide = 114,
    digit_xpos = 40,
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
    BarInsetY = 6
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
  Init = {
    { 'Animate', 'HudWeaponSelection', 'FgColor', 'WeaponSelectionColor', 'Linear', 0, 0 },
    { 'Animate', 'HudWeaponSelection', 'SelectedFgColor', 'WeaponSelectionColor', 'Linear', 0, 0 }
  },
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

HL2HUD.scheme.Register('Anomalous Materials', SCHEME)
