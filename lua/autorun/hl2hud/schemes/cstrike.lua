
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(255, 176, 0),
  FgColor = Color(255, 176, 0, 120),
  BrightFg = Color(255, 176, 0),
  DamagedFg = Color(192, 28, 0, 140),
  BrightDamagedFg = Color(192, 28, 0),
  BgColor = Color(0, 0, 0, 90),
  EmptyWeaponFg = Color(192, 28, 0),
  SelectionNumberFg = Color(255, 176, 0),
  SelectionTextFg = Color(255, 176, 0),
  SelectionEmptyBoxBg = Color(0, 0, 0, 196),
  SelectionBoxBg = Color(0, 0, 0, 196),
  SelectionSelectedBoxBg = Color(0, 0, 0, 196),
  AuxPowerLowColor = Color(192, 28, 0, 220),
  AuxPowerHighColor = Color(255, 176, 0, 220),
  SquadMemberAdded = Color(0, 255, 0),
  SquadMember = Color(0, 255, 0, 160),
  SquadMemberDying = Color(255, 0, 0, 255),
  ZoomReticleColor = Color(255, 176, 0)
})

SCHEME:Font('WeaponIconsMP', 'HL2MP', 60, 0, true)
SCHEME:Font('WeaponIconsSelected', 'HL2MP', 60, 0, true, 5, 2)
SCHEME:Font('HudNumbers', 'Counter-Strike', 28, 0, true)
SCHEME:Font('HudNumbersSmall', 'Counter-Strike', 21, 0, true)
SCHEME:Font('HudHistoryNumbers', 'Verdana', 16, 0, true)
SCHEME:Font('HudIcons', 'Counter-Strike', 28, 0, true)
SCHEME:Font('SquadIcon', 'Counter-Strike', 32, 0, true)

SCHEME:Layout({
  HudHealth = {
    xpos = 8,
    ypos = 9,
    wide = 80,
    tall = 25,
    text = 'b',
    text_font = 'HudIcons',
    text_xpos = 8,
    text_ypos = -4,
    digit_xpos = 73,
    digit_ypos = -4,
    digit_align = 2
  },
  HudSuit = {
    xpos = 148,
    ypos = 9,
    wide = 80,
    tall = 25,
    text = 'a',
    text_font = 'HudIcons',
    text_xpos = 8,
    text_ypos = -4,
    digit_xpos = 73,
    digit_ypos = -4,
    digit_align = 2
  },
  HudAmmo = {
    xpos = 15,
    ypos = 9,
    wide = 124,
    tall = 25,
    digit_xpos = 44,
    digit_ypos = -4,
    digit_align = 2,
    digit2_xpos = 50,
    digit2_ypos = 0,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 100,
    icon_ypos = 12
  },
  HudAmmoSecondary = {
    xpos = 148,
    ypos = 9,
    tall = 25,
    digit_xpos = 32,
    digit_ypos = -4,
    digit_align = 2,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 52,
    icon_ypos = 12
  },
  HudSuitPower = {
    xpos = 9,
    ypos = 43,
    wide = 80
  },
  HudAccount = {
    xpos = 15,
    ypos = 42,
    wide = 108,
    tall = 45,
    digit_xpos = 100,
    digit_ypos = 16,
    digit_align = 2,
    text_xpos = 9,
    text_ypos = 16,
    text_font = 'HudNumbers',
    text = '$',
    digit2_xpos = 100,
    digit2_ypos = -4,
    digit2_align = 2,
    digit2_font = 'HudNumbers',
    text2_xpos = 9,
    text2_ypos = -4,
    text2_font = 'HudNumbers'
  },
  HudWeaponSelection = {
    compact = false,
    uppercase = true,
    ypos = 16,
    SmallBoxSize = 60,
    LargeBoxWide = 108,
    LargeBoxTall = 80,
    TextYPos = 68,
    MoveSnd = '',
    SelectSnd = ''
  },
  HudHistoryResource = {
    NumberFont = 'HudHistoryNumbers'
  },
  HudSquadStatus = {
    xpos = 250,
    ypos = 4,
    wide = 54,
    tall = 32,
    text = '',
    IconInsetX = 4,
    IconInsetY = -4,
    IconGap = 10,
    IconMember = 'k',
    IconMedic = 'k'
  },
  HudFlashlight = {
    ypos = 9
  }
})

SCHEME:Animations({
  Init = {
    { 'Animate', 'HudSquadStatus', 'BgColor', 'Blank', 'Linear', 0, 0 },
    { 'Animate', 'HudAccount', 'BgColor', 'Blank', 'Linear', 0, 0 }
  },
  HealthIncreased = {
    { 'StopPanelAnimations', 'HudHealth', 0 },
    { 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Linear', 0, .01 }
  },
  HealthDamageTaken = {
    { 'Animate', 'HudHealth', 'FgColor', 'DamagedFg', 'Linear', 0, .1 },
    { 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Pulse', 4, .1, 1 }
  },
  HealthLow = {
    { 'Animate', 'HudHealth', 'FgColor', 'DamagedFg', 'Linear', 0, .1 },
    { 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Pulse', 2000, .1, 1000 }
  },
  SuitPowerIncreased = {},
  SuitPowerZero = {},
  SuitDamageTaken = {},
  AmmoEmpty = {},
  AmmoIncreased = {},
  AmmoDecreased = {},
  AccountMoneyAdded = {
    { 'StopEvent', param = 'AccountMoneyRemoved',  0 },
    { 'Animate', 'HudAccount', 'FgColor', 'HudIcon_Green', 'Linear',  0, 0 },
    { 'Animate', 'HudAccount', 'FgColor', 'FgColor', 'Accel',  0, 3 },
    { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Green', 'Linear',  0, 0 },
    { 'Animate', 'HudAccount', 'Ammo2Color', 'Blank', 'Accel',  0, 3 }
  },
  AccountMoneyRemoved = {
    { 'StopEvent', param = 'AccountMoneyAdded',  0 },
    { 'Animate', 'HudAccount', 'FgColor', 'HudIcon_Red', 'Linear',  0, 0 },
    { 'Animate', 'HudAccount', 'FgColor', 'FgColor', 'Accel',  0, 3 },
    { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Red', 'Linear',  0, 0 },
    { 'Animate', 'HudAccount', 'Ammo2Color', 'Blank', 'Accel',  0, 3 }
  },
  WeaponChanged = {},
  WeaponUsesClips = {},
	WeaponDoesNotUseClips = {},
  WeaponUsesSecondaryAmmo = {
    { 'StopPanelAnimations', 'HudAmmoSecondary', 0 },
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 255, 'Linear', 0, .1 }
  },
  WeaponDoesNotUseClips = {
    { 'Animate', 'HudAmmoSecondary', 'Alpha', 0, 'Linear', 0, .1 }
  },
  AmmoSecondaryEmpty = {},
  AmmoSecondaryIncreased = {},
  AmmoSecondaryDecreased = {},
  SquadStatusShow = {
    { 'StopEvent', 'SquadStatusHide', 0 },
    { 'Animate', 'HudSquadStatus', 'Alpha', 255, 'Linear', 0, .3 }
  }
})

for id, _ in pairs(HL2HUD.utils.DefaultIcons.ammo) do
  local weapon = HL2HUD.utils.AltIcons[HL2HUD.utils.DefaultIcons.ammoWeapon[id]]
  if weapon then SCHEME:AmmoWeaponIcon(id, 'WeaponIconsSmallMP', weapon, -4, 6) end
end
for class, icon in pairs(HL2HUD.utils.AltIcons) do
  SCHEME:WeaponIcon(class, 'WeaponIconsMP', icon, nil, nil, nil, 12)
  SCHEME:RemoveSelectedWeaponIcon(class)
end

HL2HUD.scheme.Register('Counter-Strike', SCHEME)
