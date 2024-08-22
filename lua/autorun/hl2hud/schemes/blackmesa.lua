
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(255, 176, 0),
  Caution = Color(255, 0, 0),
  FgColor = Color(255, 176, 0),
  BrightFg = Color(255, 176, 0),
  BgColor = Color(0, 0, 0, 0),
  BrightBg = Color(0, 0, 0, 0),
  DamagedFg = Color(255, 0, 0),
  DamagedBg = Color(0, 0, 0, 0),
  BrightDamagedFg = Color(255, 0, 0),
  SelectionNumberFg = Color(255, 220, 0),
  SelectionTextFg = Color(0, 0, 0, 0),
  SelectionEmptyBoxBg = Color(255, 176, 0, 40),
  SelectionBoxBg = Color(255, 176, 0, 80),
  SelectionSelectedBoxBg = Color(255, 176, 0, 80),
  AuxPowerHighColor = Color(255, 176, 0, 220),
  SquadMemberAdded = Color(255, 176, 0),
  SquadMember = Color(255, 176, 0, 160),
  SquadMemberLeft = Color(255, 176, 0, 0),
  SdkBgColor = Color(0, 0, 0, 76),
  SdkFgColor = Color(255, 220, 0, 100),
  SdkBrightFg = Color(255, 220, 0)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 48, 1000, true, 0, 1)
SCHEME:Font('WeaponIconsSelected', 'HalfLife2', 48, 1000, true, 6, 1)
SCHEME:Font('WeaponIconsSmall', 'HalfLife2', 32, 0, true, 0, 1)
SCHEME:Font('AuxPowerIcon', 'HalfLife2', 20, 0, true, 0, 1)
SCHEME:Font('HudNumbers', 'Alte DIN 1451 Mittelschrift', 32, 1000, true, 0, 1)
SCHEME:Font('HudNumbersGlow', 'Alte DIN 1451 Mittelschrift', 32, 1000, true, 4, 1)
SCHEME:Font('HudNumbersSmall', 'Alte DIN 1451 Mittelschrift', 16, 1000, true, 0, 1)
SCHEME:Font('HudHintTextSmall', 'Alte DIN 1451 Mittelschrift', 9, 1000, true, 0, 1)
SCHEME:Font('HudCross', 'Impact', 32, 0, true, 0, 1)
SCHEME:Font('HudBattery', 'Counter-Strike', 24, 0, true, 0, 1)
SCHEME:Font('HudSelectionNumbers', 'Alte DIN 1451 Mittelschrift', 11, 700)

SCHEME:Layout({
  HudHealth = {
    xpos = 24,
    ypos = 8,
    wide = 62,
    digit_xpos = 43,
    digit_ypos = 2,
    digit_align = 2,
    text_xpos = 44,
    text_ypos = 1,
    text = '+',
    text_font = 'HudCross'
  },
  HudSuit = {
    xpos = 86,
    ypos = 8,
    wide = 62,
    digit_xpos = 43,
    digit_ypos = 2,
    digit_align = 2,
    text_xpos = 45,
    text_ypos = 4,
    text_font = 'HudBattery',
    text = 'k'
  },
  HudAmmo = {
    xpos = 24,
    ypos = 8,
    wide = 102,
    digit_xpos = 43,
    digit_align = 2,
    digit2_xpos = 64,
    digit2_ypos = 10,
    digit2_align = 2,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 76,
    icon_ypos = 18
  },
  HudAmmoSecondary = {
    xpos = 4,
    ypos = 8,
    wide = 34,
    digit_align = 2,
    digit_xpos = 13,
    digit_ypos = 10,
    digit_font = 'HudNumbersSmall',
    digit_font_glow = 'HudNumbersSmall',
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 24,
    icon_ypos = 18
  },
  HudAccount = {
    xpos = 24,
    ypos = 45,
    wide = 102,
    tall = 46,
    digit_xpos = 92,
    digit_ypos = 12,
    digit_align = 2,
    text_xpos = 10,
    text_ypos = 19,
    text_font = 'HudNumbersSmall',
    text = '$',
    text2_xpos = 10,
    digit2_xpos = 92,
    digit2_align = 2
  },
  HudWeaponSelection = {
    compact = false,
    SmallBoxSize = 24,
    LargeBoxWide = 96,
    LargeBoxTall = 60,
    BoxGap = 4,
    SelectionNumberXPos = 12,
    SelectionNumberYPos = 3,
    SkipEmpty = true
  },
  HudSuitPower = {
    xpos = 24,
    ypos = 42,
    wide = 124,
    text_xpos = 4,
    text_ypos = 3,
    font = 'AuxPowerIcon',
    text = '*',
    text2_ypos = 32,
    BarInsetX = 18
  },
  HudSquadStatus = {
    xpos = 30,
    ypos = 34,
    text = '',
    IconGap = 20
  },
  HudHistoryResource = {
    history_gap = 32
  },
  HudFlashlight = {
    xpos = 12,
    ypos = 8,
    halign = 2,
    valign = 1
  }
})

SCHEME:Animations({
  Init = {
    { 'Animate', 'HudAccount', 'Blur', .3, 'Linear', 0, 0 }
  },
  HealthIncreased = {
    { 'StopEvent', 'HealthLow', 0 },
		{ 'Animate', 'HudHealth', 'BgColor', 'BgColor', 'Linear', 0, 0 },
		{ 'Animate', 'HudHealth', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
		{ 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Linear', .3, .75 },
		{ 'Animate', 'HudHealth', 'Blur', 3, 'Accel', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', .3, 'Deaccel', .1, 2 }
	},
  HealthDamageTaken = {
		{ 'Animate', 'HudHealth', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
		{ 'Animate', 'HudHealth', 'FgColor', 'FgColor', 'Linear', .3, .75 },
		{ 'Animate', 'HudHealth', 'Blur', 3, 'Accel', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', .3, 'Deaccel', .1, 2 }
	},
  HealthLow = {
    { 'StopEvent', 'HealthDamageTaken', 0 },
		{ 'Animate', 'HudHealth', 'FgColor', 'BrightDamagedFg', 'Linear', 0, .25 },
		{ 'Animate', 'HudHealth', 'FgColor', 'DamagedFg', 'Linear', .3, .75 },
		{ 'Animate', 'HudHealth', 'Blur', 3, 'Linear', 0, .1 },
		{ 'Animate', 'HudHealth', 'Blur', .4, 'Deaccel', .1, 2 }
	},
  SuitPowerIncreased = {
    { 'StopEvent', 'SuitPowerZero', 0 },
    { 'Animate', 'HudSuit', 'Alpha', 255, 'Linear', 0, 0 },
    { 'Animate', 'HudSuit', 'BgColor', 'BgColor', 'Linear', 0, 0 },
    { 'Animate', 'HudSuit', 'FgColor', 'FgColor', 'Linear', 0, .05 },
    { 'Animate', 'HudSuit', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'Blur', .3, 'Deaccel', .1, 2 }
  },
  SuitDamageTaken = {
    { 'Animate', 'HudSuit', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
    { 'Animate', 'HudSuit', 'FgColor', 'FgColor', 'Linear', .3, .75 },
    { 'Animate', 'HudSuit', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'Blur', .3, 'Deaccel', .1, 2 }
  },
  SuitPowerZero = {
    { 'StopEvent', 'SuitDamageTaken', 0 },
    { 'Animate', 'HudSuit', 'Alpha', 0, 'Linear', 0, .4 }
  },
  SuitArmorLow = {
    { 'Animate', 'HudSuit', 'FgColor', 'BrightDamagedFg', 'Linear', 0, .25 },
    { 'Animate', 'HudSuit', 'FgColor', 'DamagedFg', 'Linear', .3, .75 },
    { 'Animate', 'HudSuit', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'Blur', .4, 'Deaccel', .1, 2 }
  },
  AmmoIncreased = {
    { 'StopEvent', 'AmmoEmpty', 0 },
		{ 'Animate', 'HudAmmo', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
		{ 'Animate', 'HudAmmo', 'FgColor', 'FgColor', 'Deaccel', .3, .75 },
		{ 'Animate', 'HudAmmo', 'Blur', 3, 'Linear', 0, .1 },
		{ 'Animate', 'HudAmmo', 'Blur', .4, 'Accel', .1, 2 }
	},
	AmmoDecreased = {
    { 'StopEvent', 'AmmoIncreased', 0 },
    { 'Animate', 'HudAmmo', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
		{ 'Animate', 'HudAmmo', 'FgColor', 'FgColor', 'Deaccel', .3, .75 },
		{ 'Animate', 'HudAmmo', 'Blur', 3, 'Linear', 0, 0.1 },
		{ 'Animate', 'HudAmmo', 'Blur', .4, 'Deaccel', .1, 2 }
	},
  AmmoSecondaryIncreased = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Deaccel', .3, .75 }
  },
  AmmoSecondaryDecreased = {
    { 'StopEvent', 'AmmoSecondaryIncreased', 0 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'FgColor', 'Deaccel', .3, .75 }
  },
  AmmoSecondaryEmpty = {
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'BrightDamagedFg', 'Linear', 0, .2 },
    { 'Animate', 'HudAmmoSecondary', 'FgColor', 'DamagedFg', 'Accel', 0.2, 1.2 }
  },
  AccountMoneyAdded = {
    { 'StopEvent', 'AccountMoneyRemoved', 0 },
    { 'Animate', 'HudAccount', 'BgColor', 'BgColor', 'Linear', 0, 0 },
    { 'Animate', 'HudAccount', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
    { 'Animate', 'HudAccount', 'FgColor', 'FgColor', 'Linear', .3, .75 },
    { 'Animate', 'HudAccount', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudAccount', 'Blur', .3, 'Deaccel', .1, 2 },
    { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Green', 'Linear', 0, 0 },
    { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Blank', 'Accel', 0, 3 }
  },
  AccountMoneyRemoved = {
    { 'StopEvent', 'AccountMoneyAdded', 0 },
    { 'Animate', 'HudAccount', 'BgColor', 'BgColor', 'Linear', 0, 0 },
    { 'Animate', 'HudAccount', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
    { 'Animate', 'HudAccount', 'FgColor', 'FgColor', 'Linear', .3, .75 },
    { 'Animate', 'HudAccount', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudAccount', 'Blur', .3, 'Deaccel', .1, 2 },
    { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Red', 'Linear', 0, 0 },
    { 'Animate', 'HudAccount', 'Ammo2Color', 'HudIcon_Blank', 'Accel', 0, 3 }
  },
  WeaponChanged = {},
  WeaponUsesClips = {},
	WeaponDoesNotUseClips = {},
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
  },
  HintMessageShow = {
    { 'Animate', 'HudHintDisplay', 'Alpha', 255, 'Linear', 0, .5 },
    { 'Animate', 'HudHintDisplay', 'BgColor', 'SdkBgColor', 'Linear', 0, .01 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'SdkFgColor', 'Linear', 0, .01 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'SdkBrightFg', 'Linear', .5, .2 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'SdkFgColor', 'Linear', .7, .2 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'SdkBrightFg', 'Linear', 1.5, .2 },
    { 'Animate', 'HudHintDisplay', 'FgColor', 'SdkFgColor', 'Linear', 1.7, .2 },
    { 'Animate', 'HudHintDisplay', 'Alpha', 0, 'Linear', 12.0, 1.0 }
  },
  SuitAuxPowerNoItemsActive = {},
  SuitAuxPowerOneItemActive = {},
  SuitAuxPowerTwoItemsActive = {},
  SuitAuxPowerThreeItemsActive = {},
  SquadStatusShow = {
    { 'StopEvent', 'SquadStatusHide', 0 },
    { 'Animate', 'HudSquadStatus', 'Alpha', 255, 'Linear', 0, .3 },
    { 'Animate', 'HudAccount', 'Position', Vector(0, 30), 'Deaccel', 0, .5 }
  },
  PoisonDamageTaken = {
    { 'Animate', 'HudPoisonDamageIndicator', 'FgColor', 'BrightFg', 'Linear', 0, 0 },
    { 'RunEvent', 'PoisonPulse', 0 }
  },
  PoisonPulse = {
    { 'Animate', 'HudPoisonDamageIndicator', 'Alpha', 255, 'Linear', 0, .75 },
    { 'Animate', 'HudPoisonDamageIndicator', 'Alpha', 0, 'Linear', .75, 1.25 },
    { 'RunEvent', 'PoisonLoop', 2 }
  }
})

-- same sized ammunition icons
local AMMO = {
  Pistol = surface.GetTextureID('hl2hud/blackmesa/ammo_9mm'),
  ['357'] = surface.GetTextureID('hl2hud/blackmesa/ammo_357'),
  SMG1 = surface.GetTextureID('hl2hud/blackmesa/ammo_9mm'),
  SMG1_Grenade = surface.GetTextureID('hl2hud/blackmesa/ammo_grenade_mp5'),
  Buckshot = surface.GetTextureID('hl2hud/blackmesa/ammo_buckshot'),
  XBowBolt = surface.GetTextureID('hl2hud/blackmesa/ammo_bolt'),
  Grenade = surface.GetTextureID('hl2hud/blackmesa/ammo_grenade_frag'),
  RPG_Round = surface.GetTextureID('hl2hud/blackmesa/ammo_grenade_rpg'),
  slam = surface.GetTextureID('hl2hud/blackmesa/ammo_grenade_tripmine')
}
for ammo, texture in pairs(AMMO) do
  SCHEME:AmmoSprite(ammo, texture, 20, 20)
  SCHEME:AmmoPickupSprite(ammo, texture, 20, 20)
end

-- AR2AltFire icon is too big, make it smaller
local texture = surface.GetTextureID('hl2hud/blackmesa/ammo_energy')
SCHEME:AmmoSprite('AR2AltFire', texture, 16, 16)
SCHEME:AmmoPickupSprite('AR2AltFire', texture, 16, 16)

-- entities
SCHEME:EntityPickupSprite('item_healthkit', surface.GetTextureID('hl2hud/blackmesa/item_healthkit'), 20, 20)
SCHEME:EntityPickupSprite('item_battery', surface.GetTextureID('hl2hud/blackmesa/item_battery'), 20, 20)

HL2HUD.scheme.Register('Black Mesa', SCHEME)
