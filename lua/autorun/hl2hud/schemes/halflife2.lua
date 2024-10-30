
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  FgColor = Color(255, 220, 0, 100),
  BrightFg = Color(255, 220, 0)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 62, 0, true)
SCHEME:Font('WeaponIconsSelected', 'HalfLife2', 62, 0, true, 5, 2)

SCHEME:Layout({
  HudAmmo = {
    icon_visible = true,
    digit_xpos = 44
  },
  HudAmmoSecondary = {
    wide = 60,
    icon_visible = true
  },
  HudWeaponSelection = {
    compact = false,
    uppercase = true,
    TextYPos = 64,
    TextAlign = 1
  },
  HUDQuickInfo = {
    visible = true
  },
  HudHistoryResource = {
    Episodic = true,
    ShowMissingIcons = false
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

SCHEME:RemoveAmmoIcon('slam')

HL2HUD.scheme.Register('Half-Life 2', SCHEME)
