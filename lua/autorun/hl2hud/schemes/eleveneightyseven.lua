
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(255, 255, 255),
  Caution = Color(255, 48, 0),
  FgColor = Color(255, 255, 255, 100),
  BrightFg = Color(255, 255, 255),
  BrightBg = Color(255, 255, 255, 80),
  SelectionNumberFg = Color(255, 255, 255),
  SelectionTextFg = Color(0, 0, 0, 0),
  AuxPowerHighColor = Color(255, 255, 255, 220),
  SquadMemberAdded = Color(255, 255, 255),
  SquadMember = Color(255, 255, 255, 160),
  ZoomReticleColor = Color(255, 255, 255)
})

SCHEME:Font('WeaponIcons', 'HalfLife2', 64, 0, true, nil, nil, nil, HL2HUD.FONTSCALING_LIMITED)
SCHEME:Font('WeaponIconsSelected', 'HalfLife2', 64, 0, true, 5, nil, nil, HL2HUD.FONTSCALING_LIMITED)
SCHEME:Font('HudNumbers', 'Pricedown', 32, 0, true)
SCHEME:Font('HudNumbersGlow', 'Pricedown', 32, 0, true, 4)
SCHEME:Font('HudNumbersSmall', 'Pricedown', 16, 1000, true)
SCHEME:Font('HudSelectionNumbers', 'Pricedown', 11, 700)

SCHEME:Layout({
  HudAmmo = {
    icon_visible = true
  },
  HudAmmoSecondary = {
    icon_visible = true
  },
  HudWeaponSelection = {
    compact = false,
    LargeBoxTall = 64,
    TextYPos = 64
  },
  HudHistoryResource = {
    Episodic = true,
    ShowMissingIcons = false
  }
})

HL2HUD.scheme.Register('1187', SCHEME)
