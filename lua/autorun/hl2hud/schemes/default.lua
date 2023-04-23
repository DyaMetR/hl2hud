--[[------------------------------------------------------------------
  WARNING: This is the default scheme, the one the HUD falls back to
  if anything goes wrong.

  DO NOT DELETE IT
]]--------------------------------------------------------------------

if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME.default = true

SCHEME:Scheme({
  Normal = Color(255, 208, 64),
  Caution = Color(255, 48, 0),
  FgColor = Color(255, 235, 20),
  BrightFg = Color(255, 220, 0),
  DamagedFg = Color(180, 0, 0, 230),
  BrightDamagedFg = Color(255, 0, 0),
  BgColor = Color(0, 0, 0, 76),
  BrightBg = Color(250, 220, 0, 80),
  DamagedBg = Color(90, 0, 0, 80),
  BrightDamagedBg = Color(180, 0, 0, 200),
  EmptyWeaponFg = Color(255, 0, 0),
  SelectionNumberFg = Color(255, 220, 0),
  SelectionTextFg = Color(255, 220, 0),
  SelectionEmptyBoxBg = Color(0, 0, 0, 80),
  SelectionBoxBg = Color(0, 0, 0, 80),
  SelectionSelectedBoxBg = Color(0, 0, 0, 80),
  AuxPowerLowColor = Color(255, 0, 0, 220),
  AuxPowerHighColor = Color(255, 220, 0, 220),
  SquadMemberAdded = Color(255, 220, 0),
  SquadMember = Color(255, 220, 0, 160),
  SquadMemberLeft = Color(0, 0, 0),
  SquadMemberDying = Color(255, 0, 0, 255),
  SquadMemberDied = Color(0, 0, 0),
  ZoomReticleColor = Color(255, 220, 0)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 56, 0, true)
SCHEME:Font('WeaponIconsSelected', 'HalfLife2', 56, 0, true, 5, 2)
SCHEME:Font('WeaponIconsSmall', 'HalfLife2', 32, 0, true)
SCHEME:Font('WeaponIconsSmallMP', 'HL2MP', 32, 0, true)
SCHEME:Font('Crosshairs', 'HalfLife2', 40, 0, true, nil, nil, nil, false, false)
SCHEME:Font('QuickInfo', 'HL2cross', 28, 0, true)
SCHEME:Font('HudNumbers', 'HalfLife2', 32, 0, true)
SCHEME:Font('HudNumbersGlow', 'HalfLife2', 32, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'HalfLife2', 16, 1000, true)
SCHEME:Font('HudHintTextSmall', 'Verdana', 9, 1000)
SCHEME:Font('HudHintText', 'Verdana', 10, 0, true)
SCHEME:Font('HudHintTextLarge', 'Verdana', 14, 1000, true)
SCHEME:Font('HudSelectionNumbers', 'Verdana', 11, 700)
SCHEME:Font('HudSelectionText', 'Verdana', 7, 1000)
SCHEME:Font('SquadIcon', 'HalfLife2', 32, 0, true)
SCHEME:Font('MissingIcon', 'Arial', 6, 1000, true)
SCHEME:Font('Default', 'Verdana', 9, 1000)

SCHEME:Layout({
  HudHealth = {
    visible = true,
    xpos = 16,
    ypos = 12,
    wide = 102,
    tall = 36,
    halign = 1,
    valign = 2,
    digit_xpos = 50,
    digit_ypos = 2,
    digit_font = 'HudNumbers',
    digit_font_glow = 'HudNumbersGlow',
    digit_align = 1,
    text_xpos = 8,
    text_ypos = 20,
    text_font = 'HudHintTextSmall',
    text = '#Valve_Hud_HEALTH'
  },
  HudSuit = {
    visible = true,
    xpos = 140,
    ypos = 12,
    wide = 108,
    tall = 36,
    halign = 1,
    valign = 2,
    digit_xpos = 50,
    digit_ypos = 2,
    digit_font = 'HudNumbers',
    digit_font_glow = 'HudNumbersGlow',
    digit_align = 1,
    text_xpos = 8,
    text_ypos = 20,
    text_font = 'HudHintTextSmall',
    text = '#Valve_Hud_SUIT'
  },
  HudAmmo = {
    visible = true,
    xpos = 18,
    ypos = 12,
    wide = 132,
    tall = 36,
    halign = 2,
    valign = 2,
    digit_xpos = 40,
    digit_ypos = 2,
    digit_font = 'HudNumbers',
    digit_font_glow = 'HudNumbersGlow',
    digit_align = 1,
    digit2_xpos = 98,
    digit2_ypos = 16,
    digit2_font = 'HudNumbersSmall',
    digit2_align = 1,
    text_xpos = 8,
    text_ypos = 20,
    text_font = 'HudHintTextSmall',
    text = '#Valve_Hud_AMMO',
    icon_visible = false,
    icon_abspos = false,
    icon_xpos = 0,
    icon_ypos = -9
  },
  HudAmmoSecondary = {
    visible = true,
    xpos = 10,
    ypos = 12,
    wide = 72,
    tall = 36,
    halign = 2,
    valign = 2,
    digit_xpos = 26,
    digit_ypos = 2,
    digit_font = 'HudNumbers',
    digit_font_glow = 'HudNumbersGlow',
    digit_align = 1,
    text_xpos = 8,
    text_ypos = 22,
    text_font = 'HudHintTextSmall',
    text = '#Valve_Hud_AMMO_ALT',
    icon_visible = false,
    icon_abspos = false,
    icon_xpos = 0,
    icon_ypos = -9
  },
  HudSuitPower = {
    visible = true,
    xpos = 16,
    ypos = 54,
    wide = 102,
    tall = 26,
    halign = 1,
    valign = 2,
    AuxPowerDisabledAlpha = 70,
    BarInsetX = 8,
    BarInsetY = 15,
    BarWidth = 92,
    BarHeight = 4,
    BarChunkWidth = 6,
    BarChunkGap = 3,
    text_xpos = 8,
    text_ypos = 4,
    text2_xpos = 8,
    text2_ypos = 22,
    text2_gap = 10,
    font = 'HudHintTextSmall',
    text = '#Valve_Hud_AUX_POWER',
    oxygen = '#Valve_Hud_OXYGEN',
    flashlight = '#Valve_Hud_FLASHLIGHT',
    sprint = '#Valve_Hud_SPRINT'
  },
  HudFlashlight = {
    visible = true,
    xpos = 270,
    ypos = 12,
    wide = 36,
    tall = 24,
    halign = 1,
    valign = 2,
    font = 'WeaponIconsSmall',
    icon_off = '®',
    icon_on = '©',
    icon_xpos = 4,
    icon_ypos = -8,
    FlashlightDisabledAlpha = 32,
    BarInsetX = 4,
    BarInsetY = 18,
    BarWidth = 28,
    BarHeight = 2,
    BarChunkWidth = 2,
    BarChunkGap = 1,
    NormalColor = 'Normal',
    CautionColor = 'Caution'
  },
  HudZoom = {
    visible = true,
    Circle1Radius = 66,
    Circle2Radius = 74,
    DashGap = 16,
    DashHeight = 4,
    Color = 'ZoomReticleColor'
  },
  HudWeaponSelection = {
    visible = true,
    compact = true,
    uppercase = false,
    ypos = 16,
    SmallBoxSize = 32,
    LargeBoxWide = 112,
    LargeBoxTall = 80,
    BoxGap = 8,
    SelectionNumberXPos = 4,
    SelectionNumberYPos = 4,
    SelectionNumberFont = 'HudSelectionNumbers',
    TextYPos = 76, -- 64
    TextFont = 'HudSelectionText',
    TextAlign = 2, -- 1
    SkipEmpty = false,
    EmptyWeaponColor = 'EmptyWeaponFg',
    MoveSnd = 'common/wpn_moveselect.wav',
    SelectSnd = 'common/wpn_hudoff.wav'
  },
  HudCrosshair = {
    visible = true,
    font = 'Crosshairs',
    crosshair = 'Q',
    color = 'ZoomReticleColor',
    xoffset = 0,
    yoffset = 0
  },
  HudVehicle = {
    visible = true,
    wide = 32,
    tall = 32,
    crosshair = 'sprites/hud/v_crosshair1',
    color = 'Normal',
    unable = 'Caution'
  },
  HudHistoryResource = {
    visible = true,
    episodic = false,
    xpos = 4,
    ypos = 40,
    wide = 248,
    tall = 320,
    halign = 2,
    valign = 1,
    history_gap = 56,
    icon_inset = 38,
    text_inset = 36,
    NumberFont = 'HudNumbersSmall',
    DrawHistoryTime = 4,
    Color = 'Normal',
    EmptyWeaponColor = 'EmptyWeaponFg',
    TextFont = 'Default',
    AmmoFullColor = 'Caution',
    AmmoFullText = '#HL2_ammoFull',
    ShowMissingIcons = true,
    MissingIconFont = 'MissingIcon'
  },
  HUDQuickInfo = {
    visible = false,
    xpos = 10,
    ypos = 0,
    font = 'QuickInfo',
    left_bracket = '[',
    left_bracket_empty = '{',
    right_bracket = ']',
    right_bracket_empty = '}',
    left_color = 'Normal',
    right_color = 'Normal',
    warning_color = 'Caution',
    warning_sound = 'common/warning.wav'
  },
  HudHintDisplay = {
    visible = true,
    xpos = 20,
    ypos = 140,
    halign = 2,
    valign = 2,
    text_xpos = 8,
    text_ypos = 8,
    text_xgap = 8,
    text_ygap = 8,
    bind_font = 'HudHintTextLarge',
    text_font = 'HudHintText'
  },
  HudSquadStatus = {
    visible = true,
    xpos = 16,
    ypos = 54,
    wide = 104,
    tall = 46,
    halign = 2,
    valign = 2,
    text_xpos = 8,
    text_ypos = 34,
    text = '#Valve_Hud_SQUAD_FOLLOWING',
    text_font = 'HudHintTextSmall',
    SquadIconColor = 'SquadMember',
    IconInsetX = 8,
    IconInsetY = 0,
    IconGap = 24,
    IconMember = 'C',
    IconMedic = 'M',
    IconFont = 'SquadIcon'
  },
  HudPoisonDamageIndicator = {
    visible = true,
    xpos = 16,
    ypos = 96,
    halign = 1,
    valign = 2,
    wide = 136,
    tall = 38,
    text_xpos = 8,
    text_ypos = 8,
    text_ygap = 14,
    text_font = 'HudHintTextSmall',
    text = '#Valve_HudPoisonDamage'
  },
  HudDamageIndicator = {
    visible = false
  }
})

SCHEME:Animations({
  Init = {},
  OpenWeaponSelectionMenu = {
    { 'StopEvent', 'CloseWeaponSelectionMenu', 0 },
    { 'RunEvent', 'FadeOutWeaponSelectionMenu', 0 },
    { 'Animate', 'HudWeaponSelection', 'Alpha', 128, 'Linear', 0, .1 },
    { 'Animate', 'HudWeaponSelection', 'SelectionAlpha', 255, 'Linear', 0, .1 }
  },
  CloseWeaponSelectionMenu = {
    { 'StopEvent', 'FadeOutWeaponSelectionMenu', 0 },
    { 'Animate', 'HudWeaponSelection', 'Alpha', 0, 'Linear', 0, .1 },
    { 'Animate', 'HudWeaponSelection', 'SelectionAlpha', 0, 'Linear', 0, .1 }
  },
  FadeOutWeaponSelectionMenu = {
    { 'Animate', 'HudWeaponSelection', 'Alpha', 0, 'Linear', .5, 1 },
    { 'Animate', 'HudWeaponSelection', 'SelectionAlpha', 0, 'Linear', .5, 1 }
  },
  SuitAuxPowerMax = {
    { 'Animate', 'HudSuitPower', 'Alpha', 0, 'Linear', 0, .4 }
  },
  SuitAuxPowerNotMax = {
    { 'Animate', 'HudSuitPower', 'BgColor', 'BgColor', 'Linear', 0, .4 },
    { 'Animate', 'HudSuitPower', 'AuxPowerColor', 'AuxPowerHighColor', 'Linear', 0, .4 },
    { 'Animate', 'HudSuitPower', 'Alpha', 255, 'Linear', 0, .4 }
  },
  SuitAuxPowerDecreasedBelow25 = {
    { 'Animate', 'HudSuitPower', 'AuxPowerColor', 'AuxPowerLowColor', 'Linear', 0, .4 }
  },
  SuitAuxPowerIncreasedAbove25 = {
    { 'Animate', 'HudSuitPower', 'AuxPowerColor', 'AuxPowerHighColor', 'Linear', 0, .4 }
  },
  SuitAuxPowerNoItemsActive = {
    { 'Animate', 'HudSuitPower', 'Size', Vector(0, 0), 'Linear', 0, .4 }
  },
  SuitAuxPowerOneItemActive = {
    { 'Animate', 'HudSuitPower', 'Size', Vector(0, 10), 'Linear', 0, .4 }
  },
  SuitAuxPowerTwoItemsActive = {
    { 'Animate', 'HudSuitPower', 'Size', Vector(0, 20), 'Linear', 0, .4 }
  },
  SuitAuxPowerThreeItemsActive = {
    { 'Animate', 'HudSuitPower', 'Size', Vector(0, 30), 'Linear', 0, .4 }
  },
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
		{ 'Animate', 'HudHealth', 'Blur', 5, 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', 3, 'Deaccel', .1, .9 },
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
		{ 'Animate', 'HudHealth', 'Blur', 5, 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', 3, 'Deaccel', .1, .9 },
    { 'RunEvent', 'HealthPulse', 1 }
	},
  HealthLoop = {
    { 'RunEvent', 'HealthPulse', 0 }
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
  SuitPowerZero = {
    { 'StopEvent', 'SuitDamageTaken', 0 },
    { 'Animate', 'HudSuit', 'Alpha', 0, 'Linear', 0, .4 }
  },
  SuitDamageTaken = {
    { 'Animate', 'HudSuit', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
    { 'Animate', 'HudSuit', 'FgColor', 'FgColor', 'Linear', .3, .75 },
    { 'Animate', 'HudSuit', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'Blur', 0, 'Deaccel', .1, 2 }
  },
  SuitArmorLow = {
    { 'RunEvent', 'SuitDamageTaken', 0 }
  },
  SuitPulse = {
    { 'Animate', 'HudSuit', 'Blur', 5, 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'Blur', 2, 'Deaccel', .1, .8 },
    { 'Animate', 'HudSuit', 'FgColor', 'BrightDamagedFg', 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'FgColor', 'DamagedFg', 'Linear', .1, .8 },
    { 'Animate', 'HudSuit', 'BgColor', 'DamagedBg', 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'BgColor', 'BgColor', 'Deaccel', .1, .8 },
    { 'RunEvent', 'SuitLoop', .8 }
  },
  SuitLoop = {
    { 'RunEvent', 'SuitPulse', 0 }
  },
	AmmoIncreased = {
		{ 'Animate', 'HudAmmo', 'FgColor', 'BrightFg', 'Linear', 0, .15 },
		{ 'Animate', 'HudAmmo', 'FgColor', 'FgColor', 'Deaccel', .15, 1.5 },
		{ 'Animate', 'HudAmmo', 'Blur', 5, 'Linear', 0, 0 },
		{ 'Animate', 'HudAmmo', 'Blur', 0, 'Accel', .01, 1.5 }
	},
	AmmoDecreased = {
    { 'StopEvent', 'AmmoIncreased', 0 },
		{ 'Animate', 'HudAmmo', 'Blur', 7, 'Linear', 0, 0 },
		{ 'Animate', 'HudAmmo', 'Blur', 0, 'Deaccel', .1, 1.5 }
	},
	AmmoEmpty = {
		{ 'Animate', 'HudAmmo', 'FgColor', 'BrightDamagedFg', 'Linear', 0, .2 },
		{ 'Animate', 'HudAmmo', 'FgColor', 'DamagedFg', 'Accel', .2, 1.2 }
	},
	WeaponChanged = {
		{ 'Animate', 'HudAmmo', 'BgColor', 'BrightBg', 'Linear', 0, .1 },
		{ 'Animate', 'HudAmmo', 'BgColor', 'BgColor', 'Deaccel', .1, 1 },
		{ 'Animate', 'HudAmmo', 'FgColor', 'BrightFg', 'Linear', 0, .1 },
		{ 'Animate', 'HudAmmo', 'FgColor', 'FgColor', 'Linear', .2, 1.5 }
	},
	WeaponUsesClips = {
		{ 'Animate', 'HudAmmo', 'Position', Vector(0, 0), 'Deaccel', 0, .4 },
		{ 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
	},
	WeaponDoesNotUseClips = {
		{ 'Animate', 'HudAmmo', 'Position', Vector(0, 0), 'Deaccel', 0, .4 },
		{ 'Animate', 'HudAmmo', 'Size', Vector(-32, 0), 'Deaccel', 0, .4 }
	},
  AmmoSecondaryIncreased = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .15 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Deaccel', .15, 1.5 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 5, 'Linear', 0, 0 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 0, 'Accel', .01, 1.5 }
  },
  AmmoSecondaryDecreased = {
    { 'StopEvent', 'AmmoSecondaryIncreased', 0 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 7, 'Linear', 0, 0 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 0, 'Deaccel', .1, 1.5 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .1 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Deaccel', .1, .75 }
  },
  AmmoSecondaryEmpty = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightDamagedFg', 'Linear', 0, .2 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'DamagedFg', 'Accel', 0.2, 1.2 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 7, 'Linear', 0, 0 },
    { 'Animate', 'HudAmmoSecondary', 'Blur', 0, 'Deaccel', .1, 1.5 }
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
  HintMessageShow = {
    { 'Animate', 'HudHintDisplay', 'Alpha', 255, 'Linear', 0, .5 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'FgColor', 'Linear', 0, .01 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'BrightFg', 'Linear', .5, .2 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'FgColor', 'Linear', .7, .2 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'BrightFg', 'Linear', 1.5, .2 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'FgColor', 'Linear', 1.7, .2 },
    { 'Animate', 'HudHintDisplay', 'Alpha', 0, 'Linear', 12.0, 1.0 }
  },
  HintMessageHide = {
    { 'Animate', 'HudHintDisplay', 'Alpha', 0, 'Linear', 0, .5 }
  },
  HintMessageLower = {
    { 'Animate', 'HudHintDisplay', 'Position', Vector(0, 60), 'Deaccel', 0, .01 }
  },
  HintMessageRaise = {
    { 'Animate', 'HudHintDisplay', 'Position', Vector(0, 0), 'Deaccel', 0, .4 }
  },
  SquadStatusShow = {
    { 'StopEvent', 'SquadStatusHide', 0 },
    { 'Animate', 'HudSquadStatus', 'Alpha', 255, 'Linear', 0, .3 }
  },
  SquadStatusHide = {
    { 'StopEvent', 'SquadStatusShow', 0 },
    { 'Animate', 'HudSquadStatus', 'Alpha', 0, 'Linear', 0, .5 }
  },
  SquadMemberAdded = {
    { 'StopEvent', 'SquadMemberDied', 0 },
    { 'StopEvent', 'SquadMemberLeft', 0 },
    { 'Animate', 'HudSquadStatus', 'LastMemberColor', 'SquadMemberAdded', 'Linear', 0, .3 },
    { 'Animate', 'HudSquadStatus', 'LastMemberColor', 'SquadMember', 'Linear', .3, .3 }
  },
  SquadMemberLeft = {
    { 'StopEvent', 'SquadMemberDied', 0 },
    { 'StopEvent', 'SquadMemberAdded', 0 },
    { 'Animate', 'HudSquadStatus', 'LastMemberColor', 'SquadMemberLeft', 'Linear', 0, .5 }
  },
  SquadMemberDied = {
    { 'StopEvent', 'SquadMemberAdded', 0 },
    { 'StopEvent', 'SquadMemberLeft', 0 },
    { 'Animate', 'HudSquadStatus', 'LastMemberColor', 'SquadMemberDying', 'Linear', 0, .5 },
    { 'Animate', 'HudSquadStatus', 'LastMemberColor', 'SquadMemberDied', 'Linear', 2, 2 }
  },
  PoisonDamageTaken = {
    { 'Animate', 'HudPoisonDamageIndicator', 'Alpha', 255, 'Linear', 0, 1 },
    { 'RunEvent', 'PoisonPulse', 0 }
  },
  PoisonDamageCured = {
    { 'StopEvent', 'PoisonDamageTaken', 0 },
    { 'StopEvent', 'PoisonLoop', 0 },
    { 'StopEvent', 'PoisonPulse', 0 },
    { 'Animate', 'HudPoisonDamageIndicator', 'Alpha', 0, 'Linear', 0, 1 }
  },
  PoisonPulse = {
    { 'Animate', 'HudPoisonDamageIndicator', 'FgColor', 'BrightFg', 'Linear', 0, .1 },
    { 'Animate', 'HudPoisonDamageIndicator', 'FgColor', 'FgColor', 'Deaccel', .1, .8 },
    { 'Animate', 'HudPoisonDamageIndicator', 'BgColor', 'DamagedBg', 'Linear', 0, .1 },
    { 'Animate', 'HudPoisonDamageIndicator', 'BgColor', 'BgColor', 'Deaccel', .1, .8 },
    { 'RunEvent', 'PoisonLoop', .8 }
  },
  PoisonLoop = {
    { 'RunEvent', 'PoisonPulse', 0 }
  }
})

-- [[ Default Half-Life 2 icons ]] --
for id, icon in pairs(HL2HUD.utils.DefaultIcons.ammo) do
  local weapon = HL2HUD.utils.DefaultIcons.weapons[HL2HUD.utils.DefaultIcons.ammoWeapon[id]]
  SCHEME:AmmoIcon(id, 'WeaponIconsSmall', icon)
  SCHEME:AmmoPickup(id, 'WeaponIconsSmall', icon)
  if weapon then SCHEME:AmmoWeaponIcon(id, 'WeaponIconsSmall', weapon) end
end
for class, icon in pairs(HL2HUD.utils.DefaultIcons.weapons) do
  SCHEME:WeaponIcon(class, 'WeaponIcons', icon, 'WeaponIconsSelected')
end
SCHEME:EntityPickup('item_healthkit', 'WeaponIcons', '+')
SCHEME:EntityPickup('item_battery', 'WeaponIcons', '*')
SCHEME:AmmoIcon('slam', 'WeaponIconsSmallMP', HL2HUD.utils.AltIcons.weapon_slam, nil, 9)
SCHEME:AmmoPickup('slam', 'WeaponIconsSmallMP', HL2HUD.utils.AltIcons.weapon_slam)
SCHEME:WeaponSprite('weapon_annabelle', surface.GetTextureID('sprites/w_icons2'), 256, 256, 0, 128, 128, 192, 0, 0, false)
SCHEME:WeaponSelectedSprite('weapon_annabelle', surface.GetTextureID('sprites/w_icons2b'), 256, 256, 0, 128, 128, 192, 0, 0, false)

-- [[ Half-Life: Source icons ]]
local HUD1, HUD2, HUD3, HUD4, HUD5, HUD6, HUD7 = surface.GetTextureID('sprites/640hud1'), surface.GetTextureID('sprites/640hud2'), surface.GetTextureID('sprites/640hud3'), surface.GetTextureID('sprites/640hud4'), surface.GetTextureID('sprites/640hud5'), surface.GetTextureID('sprites/640hud6'), surface.GetTextureID('sprites/640hud7')
local W, H, AY, AW, AH = 170, 45, 74, 24, 23
local WEAPONS = {
  weapon_crowbar_hl1 = { 0, HUD1, HUD4 },
  weapon_glock_hl1 = { 1, HUD1, HUD4 },
  weapon_357_hl1 = { 2, HUD1, HUD4 },
  weapon_mp5_hl1 = { 3, HUD1, HUD4 },
  weapon_shotgun_hl1 = { 4, HUD1, HUD4 },
  weapon_crossbow_hl1 = { 0, HUD2, HUD5 },
  weapon_rpg_hl1 = { 1, HUD2, HUD5 },
  weapon_gauss = { 2, HUD2, HUD5 },
  weapon_egon = { 3, HUD2, HUD5 },
  weapon_hornetgun = { 4, HUD2, HUD5 },
  weapon_handgrenade = { 0, HUD3, HUD6 },
  weapon_satchel = { 1, HUD3, HUD6 },
  weapon_tripmine = { 2, HUD3, HUD6 },
  weapon_snark = { 3, HUD3, HUD6 }
}
local AMMOTYPES = {
  ['9mmRound'] = { 0, 0 },
  ['357Round'] = { 0, 1 },
  MP5_Grenade = { 0, 2 },
  BuckshotHL1 = { 0, 3 },
  XBowBoltHL1 = { 0, 4 },
  RPG_Rocket = { 0, 5 },
  Uranium = { 1, 0 },
  Hornet = { 1, 1 },
  GrenadeHL1 = { 1, 2 },
  Satchel = { 1, 3 },
  Snark = { 1, 4 },
  TripMine = { 1, 5 }
}
for class, icon in pairs(WEAPONS) do
  SCHEME:WeaponSprite(class, icon[2], 256, 256, 0, H * icon[1], W, H * (icon[1] + 1), 0, 0, false)
  SCHEME:WeaponSelectedSprite(class, icon[3], 256, 256, 0, H * icon[1], W, H * (icon[1] + 1), 0, 0, false)
end
for ammotype, icon in pairs(AMMOTYPES) do
  SCHEME:AmmoPickupSprite(ammotype, HUD7, 256, 128, AW * icon[2], AY + AH * icon[1], AW * (icon[2] + 1), AY + AH * (icon[1] + 1), 0, 1, false)
  SCHEME:AmmoSprite(ammotype, HUD7, 256, 128, AW * icon[2], AY + AH * icon[1], AW * (icon[2] + 1), AY + AH * (icon[1] + 1), 0, 2, false)
end

HL2HUD.scheme.Register('Default', SCHEME)
