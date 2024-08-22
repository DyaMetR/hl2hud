
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(255, 176, 86),
  FgColor = Color(255, 176, 86, 160),
  BrightFg = Color(255, 200, 100),
  BrightBg = Color(255, 200, 100, 80),
  SelectionNumberFg = Color(255, 176, 86),
  SelectionTextFg = Color(255, 176, 86),
  AuxPowerHighColor = Color(255, 176, 86, 220),
  SquadMemberAdded = Color(255, 200, 100),
  SquadMember = Color(255, 176, 86, 160),
  ZoomReticleColor = Color(255, 176, 86)
})

SCHEME:Font('HudNumbers', 'Akbar', 32, 0, true)
SCHEME:Font('HudNumbersGlow', 'Akbar', 32, 0, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'Akbar', 16, 1000, true)
SCHEME:Font('HudHintTextSmall', 'Akbar', 9, 1000, true)
SCHEME:Font('HudHintText', 'Akbar', 10, 0, true)
SCHEME:Font('HudHintTextLarge', 'Akbar', 14, 1000, true)
SCHEME:Font('HudSelectionNumbers', 'Akbar', 14, 700, true)
SCHEME:Font('HudSelectionText', 'Akbar', 9, 1000, true)
SCHEME:Font('Default', 'Akbar', 9, 1000)

SCHEME:Layout({
  HudHealth = {
    wide = 84,
    tall = 40,
    digit_xpos = 32,
    digit_ypos = -1,
    text_xpos = 7,
    text_ypos = 26,
    text = 'AWARENESS'
  },
  HudSuit = {
    xpos = 108,
    wide = 84,
    tall = 40,
    digit_xpos = 32,
    digit_ypos = -1,
    text_xpos = 7,
    text_ypos = 26,
    text = 'PROTECTION'
  },
  HudAmmo = {
    wide = 100,
    tall = 40,
    digit_xpos = 32,
    digit_ypos = -1,
    digit2_xpos = 66,
    digit2_ypos = 4,
    text_xpos = 7,
    text_ypos = 26,
    text = 'ARMAMENT'
  },
  HudAmmoSecondary = {
    wide = 72,
    tall = 40,
    digit_xpos = 46,
    digit_ypos = -1,
    digit_align = 2,
    text_xpos = 7,
    text_ypos = 26,
    text = 'ALTERNATIVE'
  },
  HudSuitPower = {
    tall = 21,
    BarInsetY = 8,
    BarHeight = 6,
    BarChunkWidth = 6,
    BarChunkGap = 4,
    text2_ypos = 16,
    text = '',
    oxygen = 'BREATHE',
    flashlight = 'LUMINOSITY',
    sprint = 'SWIFTNESS'
  },
  HudFlashlight = {
    xpos = 16,
    halign = 2,
    valign = 1,
    icon_ypos = -9,
    BarInsetX = 6,
    BarInsetY = 16,
    BarHeight = 4,
    BarChunkWidth = 4,
    BarChunkGap = 2
  },
  HudAccount = {
    wide = 114,
    tall = 40,
    xpos = 18,
    digit_xpos = 32,
    digit_ypos = -1,
    text_xpos = 7,
    text_ypos = 26,
    text = 'WEALTH',
    digit2_xpos = 48,
    digit2_ypos = 24,
    text2_xpos = 41,
    text2_ypos = 24
  },
  HudSquadStatus = {
    xpos = 18,
    wide = 84,
    tall = 40,
    text_ypos = 26,
    text = 'FOLLOWING',
    IconInsetX = 31,
    IconInsetY = -5,
    IconGap = 13
  }
})

SCHEME:Sequence('SquadStatusShow', {
  { 'StopEvent', 'SquadStatusHide', 0 },
  { 'Animate', 'HudSquadStatus', 'Alpha', 255, 'Linear', 0, .3 },
  { 'Animate', 'HudAccount', 'Position', Vector(0, 42), 'Deaccel', 0, .5 }
})

HL2HUD.scheme.Register('Wasteland', SCHEME)
