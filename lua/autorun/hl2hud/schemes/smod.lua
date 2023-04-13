
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(0, 80, 255),
  FgColor = Color(0, 128, 255),
  BrightFg = Color(128, 255, 255),
  BrightBg = Color(0, 128, 255, 80),
  SelectionNumberFg = Color(255, 255, 255),
  SelectionTextFg = Color(255, 255, 255),
  SelectionEmptyBoxBg = Color(32, 0, 0, 80),
  SelectionSelectedBoxBg = Color(0, 0, 0, 128),
  AuxPowerHighColor = Color(128, 255, 128, 220),
  SquadMemberAdded = Color(255, 255, 255),
  SquadMember = Color(255, 255, 255),
  Crosshair = Color(255, 255, 255),
  ZoomReticleColor = Color(255, 0, 0)
})

SCHEME:Font('WeaponIconsMP', 'HL2MP', 28, 0, true)
SCHEME:Font('WeaponIconsSmallMP', 'HL2MP', 32, 0, true)
SCHEME:Font('HudIcons', 'HalfLife2', 24, 0, true)
SCHEME:Font('HudIconsSmall', 'HalfLife2', 16, 0, true)
SCHEME:Font('HudNumbers', 'SMODGUI', 24, 0, true)
SCHEME:Font('HudNumbersGlow', 'SMODGUI', 24, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'SMODGUI', 12, 300, true)
SCHEME:Font('HudSelectionNumbers', 'SMODGUI', 11, 700)
SCHEME:Font('HudSelectionText', 'SMODGUI', 8, 1000)

SCHEME:Layout({
  HudHealth = {
  	xpos			= 16,
  	ypos			= 40,
  	wide			= 60,
  	tall			= 25,
  	halign		= 1,
  	valign		= 2,
  	digit_xpos	= 24,
  	digit_ypos	= 2,
  	digit_font	= 'HudNumbers',
  	digit_font_glow	= 'HudNumbersGlow',
  	text_xpos	= 4,
  	text_ypos	= -3,
  	text_font	= 'HudIcons',
  	text		= '+'
  },
  HudSuit = {
  	xpos			= 16,
  	ypos			= 12,
  	wide			= 60,
  	tall			= 25,
  	halign		= 1,
  	valign		= 2,
  	digit_xpos	= 24,
  	digit_ypos	= 2,
  	digit_font	= 'HudNumbers',
  	digit_font_glow	= 'HudNumbersGlow',
  	text_xpos	= 4,
  	text_ypos	= -3,
  	text_font	= 'HudIcons',
  	text		= '*'
  },
  HudAmmo = {
  	xpos = 18,
  	ypos = 12,
  	wide = 60,
  	tall = 25,
  	halign = 2,
  	valign = 2,
  	digit_xpos = 29,
  	digit_ypos = 2,
  	digit_font = 'HudNumbers',
  	digit_font_glow = 'HudNumbersGlow',
  	digit2_xpos = 4,
  	digit2_ypos = 3,
  	digit2_font = 'HudNumbersSmall',
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 15,
    icon_ypos = 20
  },
  HudAmmoSecondary = {
  	xpos = 18,
  	ypos = 12,
  	wide = 25,
  	tall = 25,
  	halign = 2,
  	valign = 2,
  	digit_xpos = 4,
  	digit_ypos = 2,
  	digit_font = 'HudNumbers',
  	digit_font_glow = 'HudNumbersGlow',
  	text_xpos = 0,
  	text_ypos = 0,
  	text_font = 'HudHintTextSmall',
  	text = ''
  },
  HudSuitPower = {
    xpos = 220,
    ypos = 17,
    wide = 200,
    tall = 14,
    AuxPowerDisabledAlpha = 50,
    BarInsetX = 14,
    BarInsetY = 4,
    BarWidth = 180,
    BarHeight = 6,
    BarChunkWidth = 1,
    text_xpos = 4,
    text_ypos = -4,
    font = 'HudIconsSmall',
    text = '*',
    text2_ypos = 24
  },
  HudWeaponSelection = {
    compact = false,
    uppercase = true,
    LargeBoxWide = 128,
    LargeBoxTall = 32,
    TextYPos = 4,
    TextAlign = 1,
    SkipEmpty = true
  },
  HudCrosshair = {
    color = 'Crosshair'
  },
  HudSquadStatus = {
    wide = 89,
    tall = 30,
    text_xpos = 4,
    text_ypos = 18,
    IconInsetX = 4,
    IconInsetY = -6,
    IconFont = 'HudIcons'
  },
  HudDamageIndicator = {
    visible = true
  },
  HudFlashlight = {
    xpos = 16,
    ypos = 12,
    halign = 2,
    valign = 1,
    NormalColor = 'FgColor',
    BarChunkWidth = 1,
    BarChunkGap = 1,
    BarWidth = 24
  }
})

SCHEME:Animations({
  OpenWeaponSelectionMenu = {
    { 'StopEvent', 'CloseWeaponSelectionMenu', 0 },
    { 'RunEvent', 'FadeOutWeaponSelectionMenu', 0 },
    { 'Animate', 'HudWeaponSelection', 'Alpha', 128, 'Linear', 0, .1 },
    { 'Animate', 'HudWeaponSelection', 'SelectionAlpha', 255, 'Linear', 0, .1 },
    { 'Animate', 'HudWeaponSelection', 'SelectedFgColor', 'FgColor', 'Linear', 0, .1 },
    { 'Animate', 'HudWeaponSelection', 'TextColor', 'BrightFg', 'Linear', 0, .1 }
  },
  WeaponDoesNotUseClips = {},
  WeaponUsesSecondaryAmmo = {
    { 'StopAnimation', 'HudAmmo', 'Position', 0 },
    { 'StopPanelAnimations', 'HudAmmoSecondary', 0 },
    { 'Animate', 'HudAmmoSecondary', 'BgColor', 'BrightBg', 'Linear', 0, .1 },
    { 'Animate', 'HudAmmoSecondary', 'BgColor', 'BgColor', 'Deaccel', .1, 1 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .1 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Linear', .2, 1.5 },
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 255, 'Linear', 0, .1 },
    { 'Animate', 'HudAmmo', 'Position', Vector(28, 0), 'Deaccel', 0, .5 }
	},
  SuitAuxPowerNoItemsActive = {},
  SuitAuxPowerOneItemActive = {},
  SuitAuxPowerTwoItemsActive = {},
  SuitAuxPowerThreeItemsActive = {},
  SquadStatusShow = {
    { 'StopEvent', 'SquadStatusHide', 0 },
    { 'Animate', 'HudSquadStatus', 'Alpha', 255, 'Linear', 0, .3 },
    { 'Animate', 'HudSquadStatus', 'SquadTextColor', 'FgColor', 'Linear', 0, .3 }
  }
})

for id, icon in pairs(HL2HUD.utils.DefaultIcons.ammo) do
  SCHEME:AmmoIcon(id, 'HudIcons', icon)
  local weapon = HL2HUD.utils.DefaultIcons.weapons[HL2HUD.utils.DefaultIcons.ammoWeapon[id]]
  if weapon then SCHEME:AmmoWeaponIcon(id, 'WeaponIconsSmallMP', weapon) end
end
for class, icon in pairs(HL2HUD.utils.AltIcons) do
  SCHEME:WeaponIcon(class, 'WeaponIconsMP', icon, nil, nil, nil, 8)
  SCHEME:RemoveSelectedWeaponIcon(class)
end

HL2HUD.scheme.Register('SMOD', SCHEME)
