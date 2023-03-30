
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  FgColor = Color(255, 220, 0, 100),
  BrightFg = Color(255, 220, 0),
  SelectionTextFg = Color(0, 0, 0, 0)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 62, 0, true)
SCHEME:Font('WeaponIconsSelected', 'HalfLife2', 62, 0, true, 5, 2)
SCHEME:Font('HudIcons', 'HalfLife2', 34, 0, true)

SCHEME:Layout({
  HudHealth = {
    wide = 82,
    digit_xpos = 32,
    text = '+',
    text_font = 'HudIcons',
    text_xpos = 10,
    text_ypos = -3
  },
  HudSuit = {
    xpos = 120,
    wide = 82,
    digit_xpos = 32,
    text = '*',
    text_font = 'HudIcons',
    text_xpos = 10,
    text_ypos = -3
  },
  HudAmmo = {
    digit_xpos = 44,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 24,
    icon_ypos = 18
  },
  HudAmmoSecondary = {
    wide = 60,
    text = '',
    icon_visible = true,
    icon_abspos = true,
    icon_xpos = 16,
    icon_ypos = 18
  },
  HudWeaponSelection = {
    compact = false,
    uppercase = true,
    TextYPos = 64,
    TextAlign = 1,
    SkipEmpty = true
  },
  HudSquadStatus = {
    tall = 40,
    text = ''
  }
})

SCHEME:Sequence('WeaponUsesSecondaryAmmo', {
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
})

HL2HUD.scheme.Register('Iconic', SCHEME)
