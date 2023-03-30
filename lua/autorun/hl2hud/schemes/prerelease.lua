
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Colour('BgColor', Color(0, 0, 0, 100))
SCHEME:Colour('FgColor', Color(255, 220, 0, 100))
SCHEME:Colour('BrightFg', Color(255, 220, 0))
SCHEME:Colour('DamagedBg', Color(90, 0, 0, 140))

SCHEME:Font('WeaponIcons', 'HalfLife2', 46, 0, true)
SCHEME:Font('WeaponIconsSelected', 'HalfLife2', 46, 0, true, 5, 2)
SCHEME:Font('HudNumbers', 'DIN-Light', 32, 1000, true)
SCHEME:Font('HudNumbersGlow', 'DIN-Light', 32, 1000, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'DIN-Regular', 16, 1000, true)
SCHEME:Font('HudNumbersTiny', 'DIN-Regular', 16, 1000, true, nil, nil, nil, false)

SCHEME:Layout({
  HudHealth = {
    digit_xpos = 92,
    digit_align = 2,
  },
  HudSuit = {
    digit_xpos = 92,
    digit_align = 2
  },
  HudAmmo = {
    digit_xpos = 86,
    digit_align = 2,
    digit2_xpos = 120,
    digit2_align = 2
  },
  HudAmmoSecondary = {
    xpos = 13,
    wide = 60,
    digit_xpos = 51,
    digit_align = 2,
    text = ''
  },
  HudWeaponSelection = {
    compact = false,
    uppercase = true,
    LargeBoxWide = 108,
    LargeBoxTall = 64,
    TextYPos = 48,
    TextAlign = 1,
    SkipEmpty = true
  },
  HudSuitPower = {
    tall = 30,
    BarInsetY = 8,
    text_ypos = 15,
    text2_ypos = 32
  },
  HudHistoryResource = {
    icon_inset = 48,
    text_inset = 40,
    NumberFont = 'HudNumbersTiny',
    ShowMissingIcons = false
  }
})

SCHEME:Animations({
  SuitArmorLow = {
    { 'StopEvent', 'SuitDamageTaken', 0 },
    { 'StopEvent', 'SuitPulse', 0 },
    { 'StopEvent', 'SuitLoop', 0 },
    { 'Animate', 'HudSuit', 'BgColor', 'DamagedBg', 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'BgColor', 'BgColor', 'Deaccel', .1, 1.75 },
    { 'Animate', 'HudSuit', 'FgColor', 'BrightFg', 'Linear', 0, .25 },
    { 'Animate', 'HudSuit', 'FgColor', 'FgColor', 'Linear', .3, .75 },
    { 'Animate', 'HudSuit', 'Blur', 3, 'Linear', 0, .1 },
    { 'Animate', 'HudSuit', 'Blur', 0, 'Deaccel', .1, 2 },
    { 'RunEvent', 'SuitPulse', 1 }
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
  	{ 'Animate', 'HudAmmo', 'Position', Vector(60, 0), 'Deaccel', 0, .5 },
  	{ 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
  },
  SuitAuxPowerNoItemsActive = {},
  SuitAuxPowerOneItemActive = {},
  SuitAuxPowerTwoItemsActive = {},
  SuitAuxPowerThreeItemsActive = {}
})

local TEXTURE, DIMENSIONS = surface.GetTextureID('hl2hud/prerelease/a_icons1'), 256
local AMMOTYPES = {
  RPG_Round = { 0, 3, 126, 27, 8 },
  SniperRound = { 59, 33, 126, 43 },
  AR2 = { 74, 48, 126, 57 },
  SMG1 = { 87, 64, 126, 72 },
  Pistol = { 103, 79, 126, 87 },
  Buckshot = { 90, 93, 126, 106 },
  SMG1_Grenade = { 93, 113, 126, 127 },
  ['357'] = { 99, 156, 126, 166 },
  AR2AltFire = { 29, 93, 52, 116 }
}
for ammotype, icon in pairs(AMMOTYPES) do
  SCHEME:AmmoPickupSprite(ammotype, TEXTURE, DIMENSIONS, DIMENSIONS, icon[1], icon[2], icon[3], icon[4], nil, nil, false)
  SCHEME:AmmoSprite(ammotype, TEXTURE, DIMENSIONS, DIMENSIONS, icon[1], icon[2], icon[3], icon[4], icon[5], 1, false)
end
SCHEME:EntityPickupSprite('item_healthkit', TEXTURE, DIMENSIONS, DIMENSIONS, 35, 31, 54, 50, nil, nil, false)
SCHEME:EntityPickupSprite('item_battery', TEXTURE, DIMENSIONS, DIMENSIONS, 35, 62, 54, 81, nil, nil, false)
SCHEME:RemoveAmmoPickup('slam')

HL2HUD.scheme.Register('Leak', SCHEME)
