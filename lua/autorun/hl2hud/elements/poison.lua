
local NET = HL2HUD.hookname .. '_poison'

if SERVER then

  util.AddNetworkString(NET)

  local POISON_VAR, RESTORED_VAR = 'm_nPoisonDmg', 'm_nPoisonRestored'
  local POISON_DELAY, POISON_RESTORE_RATE = 2, 10

  -- [[ Send how long must the poison damage indicator be displayed for ]] --
  hook.Add('EntityTakeDamage', NET, function(_player, damage)
    if not _player:IsPlayer() or not damage:IsDamageType(DMG_POISON) then return end
    local poison, restored = _player:GetInternalVariable(POISON_VAR) + damage:GetDamage(), _player:GetInternalVariable(RESTORED_VAR)
    net.Start(NET)
    net.WriteFloat(math.ceil((poison - restored) / POISON_RESTORE_RATE) * POISON_DELAY)
    net.Send(_player)
  end)

end

if SERVER then return end

local BREAKLINE = '\n'

local ELEMENT = HL2HUD.elements.Register('HudPoisonDamageIndicator', 'CHudPoisonDamageIndicator')

ELEMENT:Boolean('visible')
ELEMENT:Number('xpos')
ELEMENT:Number('ypos')
ELEMENT:Number('wide')
ELEMENT:Number('tall')
ELEMENT:Number('halign')
ELEMENT:Number('valign')
ELEMENT:Number('text_xpos')
ELEMENT:Number('text_ypos')
ELEMENT:Number('text_ygap')
ELEMENT:Font('text_font')
ELEMENT:String('text')

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

function ELEMENT:Init()
  self:Variable('BgColor', table.Copy(self.colours.BgColor))
  self:Variable('FgColor', table.Copy(self.colours.FgColor))
  self:Variable('Position', Vector(0, 0))
  self:Variable('Size', Vector(0, 0))
  self:Variable('Alpha', 0)
end

local m_bFakeCured = false
local m_flPoisonCureTime, m_bPoisoned = 0, false
function ELEMENT:OnThink()
  if not m_bPoisoned then return end
  local localPlayer = LocalPlayer()
  if m_flPoisonCureTime < CurTime() or not localPlayer:Alive() then
    HL2HUD.animations.StartAnimationSequence('PoisonDamageCured')
    m_bPoisoned = false
    return
  end
  if localPlayer:Health() >= localPlayer:GetMaxHealth() and not m_bFakeCured then
    HL2HUD.animations.StartAnimationSequence('PoisonDamageCured')
    m_bFakeCured = true
  elseif localPlayer:Health() < localPlayer:GetMaxHealth() and m_bFakeCured then
    HL2HUD.animations.StartAnimationSequence('PoisonDamageTaken')
    m_bFakeCured = false
  end
end

function ELEMENT:Draw(settings, scale)
  local x, y = (settings.xpos + self.variables.Position.x) * scale, (settings.ypos + self.variables.Position.y) * scale
  local w, h = (settings.wide + self.variables.Size.x) * scale, (settings.tall + self.variables.Size.y) * scale
  local text = language.GetPhrase(settings.text)
  if settings.halign > 1 then x = ScrW() - (x + w) end
  if settings.valign > 1 then y = ScrH() - (y + h) end
  render.SetScissorRect(x, y, x + w, y + h, true)
  surface.SetAlphaMultiplier(self.variables.Alpha / 255)
  draw.RoundedBox(8, x, y, w, h, self.variables.BgColor)
  for i, line in pairs(string.Split(text, BREAKLINE)) do
    draw.DrawText(line, self.fonts.text_font, x + settings.text_xpos * scale, y + (settings.text_ypos + settings.text_ygap * (i - 1)) * scale, self.variables.FgColor)
  end
  surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end

-- [[ Receive poison damage ]] --
net.Receive(NET, function(len)
  HL2HUD.animations.StartAnimationSequence('PoisonDamageTaken')
  m_flPoisonCureTime = CurTime() + net.ReadFloat()
  m_bPoisoned = true
end)
