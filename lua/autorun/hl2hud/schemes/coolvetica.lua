
if SERVER then return end

local SCHEME = HL2HUD.scheme.Create()

SCHEME:Scheme({
  Normal = Color(35, 115, 255),
  BgColor = Color(0, 0, 0, 100),
  FgColor = Color(0, 130, 255, 200),
  BrightFg = Color(70, 200, 255),
  BrightBg = Color(0, 130, 255, 80),
  SelectionNumberFg = Color(0, 130, 255),
  SelectionTextFg = Color(0, 130, 255),
  AuxPowerHighColor = Color(0, 130, 255, 220),
  SquadMemberAdded = Color(0, 130, 255),
  SquadMember = Color(0, 130, 255, 160),
  ZoomReticleColor = Color(35, 115, 255)
})

SCHEME:Font('WeaponIconsMP', 'HL2MP', 60, 0, true)
SCHEME:Font('WeaponIconsSelected', 'HL2MP', 60, 0, true, 5, 2)
SCHEME:Font('WeaponIconsSmallMP', 'HL2MP', 32, 0, true)
SCHEME:Font('HudNumbers', 'Coolvetica', 35, 500, true)
SCHEME:Font('HudNumbersGlow', 'Coolvetica', 35, 500, true, 4, 2)
SCHEME:Font('HudNumbersSmall', 'Coolvetica', 16, 500, true)
SCHEME:Font('HudHintTextSmall', 'Tahoma', 10, 1000, true)

SCHEME:Layout({
  HudHealth = {
    digit_ypos = 3
  },
  HudSuit = {
    digit_ypos = 3
  },
  HudAmmo = {
    digit_ypos = 3,
    digit2_ypos = 17
  },
  HudAmmoSecondary = {
    text_ypos = 20,
    digit_ypos = 3
  }
})

SCHEME:Sequence('Init', {
  { 'Animate', 'HudWeaponSelection', 'SelectedFgColor', 'FgColor', 'Linear', 0, .1 }
})

for id, _ in pairs(HL2HUD.utils.DefaultIcons.ammo) do
  local weapon = HL2HUD.utils.AltIcons[HL2HUD.utils.DefaultIcons.ammoWeapon[id]]
  if weapon then SCHEME:AmmoWeaponIcon(id, 'WeaponIconsSmallMP', weapon, -4, 6) end
end
for class, icon in pairs(HL2HUD.utils.AltIcons) do
  SCHEME:WeaponIcon(class, 'WeaponIconsMP', icon, 'WeaponIconsSelected', nil, nil, 12)
end

HL2HUD.scheme.Register('Coolvetica Fever', SCHEME)
