
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(0, 255, 217),
  FgColor = Color(0, 255, 217, 100),
  BrightFg = Color(0, 255, 217),
  BrightBg = Color(0, 255, 217, 80),
  SelectionNumberFg = Color(0, 255, 217),
  SelectionTextFg = Color(0, 255, 217),
  AuxPowerHighColor = Color(0, 255, 217, 220),
  SquadMemberAdded = Color(0, 255, 217),
  SquadMember = Color(0, 255, 217, 160),
  ZoomReticleColor = Color(0, 255, 217)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 62, 0, true)
SCHEME:Font('WeaponIconsSelected', 'HalfLife2', 62, 0, true, 5, 2)
SCHEME:Font('HudNumbers', 'Android Insomnia', 32, 0, true)
SCHEME:Font('HudNumbersGlow', 'Android Insomnia', 32, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'Android Insomnia', 16, 1000, true)
SCHEME:Font('HudHintTextSmall', 'Android Insomnia', 9, 1000)
SCHEME:Font('HudHintText', 'Android Insomnia', 10, 0, true)
SCHEME:Font('HudHintTextLarge', 'Android Insomnia', 14, 1000, true)
SCHEME:Font('HudSelectionNumbers', 'Android Insomnia', 11, 700)
SCHEME:Font('HudSelectionText', 'Android Insomnia', 7, 1000)

SCHEME:Layout({
  HudSuit = {
    text = 'PCV'
  },
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
    TextAlign = 1,
    SkipEmpty = true
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

HL2HUD.scheme.Register('Entropy Zero', SCHEME)
