
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  FgColor = Color(255, 220, 0, 100),
  BrightFg = Color(255, 220, 0)
})

SCHEME:Layout({
  HudHealth = {
    wide = 58,
    tall = 44,
    digit_xpos = 7,
    digit_ypos = 9,
    text_xpos = 7,
    text_ypos = 4
  },
  HudSuit = {
    xpos = 80,
    wide = 58,
    tall = 44,
    digit_xpos = 7,
    digit_ypos = 9,
    text_xpos = 7,
    text_ypos = 4
  },
  HudAmmo = {
    wide = 85,
    tall = 44,
    digit_xpos = 7,
    digit_ypos = 9,
    digit2_xpos = 55,
    digit2_ypos = 21,
    text_ypos = 4
  },
  HudAmmoSecondary = {
    wide = 44,
    tall = 44,
    digit_xpos = 7,
    digit_ypos = 9,
    text_ypos = 4
  },
  HudSuitPower = {
    ypos = 60
  },
  HudAccount = {
    xpos = 17,
    ypos = 61,
    wide = 86,
    tall = 44,
    digit_xpos = 7,
    digit_ypos = 9,
    text_xpos = 7,
    text_ypos = 4,
    digit2_xpos = 48,
    digit2_ypos = 0,
    text2_ypos = 1,
    text2_xpos = 39
  },
  HudSquadStatus = {
    ypos = 60
  },
  HudPoisonDamageIndicator = {
    ypos = 100
  },
  HudFlashlight = {
    xpos = 144
  }
})

SCHEME:Animations({
  WeaponDoesNotUseClips = {
		{ 'Animate', 'HudAmmo', 'Position', Vector(0, 0), 'Deaccel', 0, .4 },
		{ 'Animate', 'HudAmmo', 'Size', Vector(-28, 0), 'Deaccel', 0, .4 }
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
  	{ 'Animate', 'HudAmmo', 'Position', Vector(42, 0), 'Deaccel', 0, .5 },
  	{ 'Animate', 'HudAmmo', 'Size', Vector(0, 0), 'Deaccel', 0, .4 }
  },
  SquadStatusShow = {
    { 'StopEvent', 'SquadStatusHide', 0 },
    { 'Animate', 'HudSquadStatus', 'Alpha', 255, 'Linear', 0, .3 },
    { 'Animate', 'HudAccount', 'Position', Vector(0, 48), 'Deaccel', 0, .5 }
  }
})

HL2HUD.scheme.Register('Compact', SCHEME)
