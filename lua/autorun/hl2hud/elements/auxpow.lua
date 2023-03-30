
if SERVER then return end

local HOOK_AUXPOW   = 'HL2HUD_GetAuxPower'
local HOOK_ACTIONS  = 'HL2HUD_GetAuxPowerActions'

local ANIMATIONS = {
  'SuitAuxPowerNoItemsActive',
  'SuitAuxPowerOneItemActive',
  'SuitAuxPowerTwoItemsActive',
  'SuitAuxPowerThreeItemsActive'
}

local ELEMENT = HL2HUD.elements.Register('HudSuitPower', 'CHudSuitPower')

ELEMENT:Boolean('visible')
ELEMENT:Number('xpos')
ELEMENT:Number('ypos')
ELEMENT:Number('wide')
ELEMENT:Number('tall')
ELEMENT:Alignment('halign')
ELEMENT:Alignment('valign')
ELEMENT:Number('AuxPowerDisabledAlpha')
ELEMENT:Number('BarInsetX')
ELEMENT:Number('BarInsetY')
ELEMENT:Number('BarWidth')
ELEMENT:Number('BarHeight')
ELEMENT:Number('BarChunkWidth')
ELEMENT:Number('BarChunkGap')
ELEMENT:Number('text_xpos')
ELEMENT:Number('text_ypos')
ELEMENT:Number('text2_xpos')
ELEMENT:Number('text2_ypos')
ELEMENT:Number('text2_gap')
ELEMENT:Font('font')
ELEMENT:String('text')
ELEMENT:String('oxygen')
ELEMENT:String('flashlight')
ELEMENT:String('sprint')

local lastCount = 0
local lastPower = 1
function ELEMENT:Init(settings)
  self:Variable('BgColor', table.Copy(self.colours.BgColor))
  self:Variable('AuxPowerColor', table.Copy(self.colours.AuxPowerHighColor))
  self:Variable('Position', Vector(0, 0))
  self:Variable('Size', Vector(0, 0))
  self:Variable('Alpha', 0)
  lastPower = 1
  lastCount = 0
end

local actions = {}
function ELEMENT:OnThink(settings)
  local auxpow = hook.Run(HOOK_AUXPOW) or LocalPlayer():GetSuitPower() * .01

  -- fetch vanilla labels
  table.Empty(actions)
  local localPlayer = LocalPlayer()
  if localPlayer:WaterLevel() >= 3 then table.insert(actions, settings.oxygen) end
  if localPlayer:FlashlightIsOn() then table.insert(actions, settings.flashlight) end
  if localPlayer:IsSprinting() then table.insert(actions, settings.sprint) end
  labels = hook.Run(HOOK_ACTIONS) or actions

  -- resize depending on amount of labels shown
  local count = #labels
  if lastCount ~= count then
    HL2HUD.animations.StartAnimationSequence(ANIMATIONS[math.min(count + 1, 4)])
    lastCount = count
  end

  -- change colours
  if lastPower ~= auxpow then
    if lastPower >= 1 then
      HL2HUD.animations.StartAnimationSequence('SuitAuxPowerNotMax')
    else
      if auxpow >= 1 then
        HL2HUD.animations.StartAnimationSequence('SuitAuxPowerMax')
      else
        if lastPower > .25 and auxpow <= .25 then
          HL2HUD.animations.StartAnimationSequence('SuitAuxPowerDecreasedBelow25')
        elseif lastPower <= .25 and auxpow > .25 then
          HL2HUD.animations.StartAnimationSequence('SuitAuxPowerIncreasedAbove25')
        end
      end
    end
    lastPower = auxpow
  end
end

function ELEMENT:Draw(settings, scale)
  local alpha = self.variables.Alpha / 255

  -- get dimensions
  local inx, iny, chw, bh, gap = settings.BarInsetX * scale, settings.BarInsetY * scale, settings.BarChunkWidth * scale, settings.BarHeight * scale, settings.BarChunkGap * scale
  local x, y = (settings.xpos + self.variables.Position.x) * scale, (settings.ypos + self.variables.Position.y) * scale
  local w, h = (settings.wide + self.variables.Size.x) * scale, (settings.tall + self.variables.Size.y) * scale
  if settings.halign > 1 then x = ScrW() - (x + w) end
  if settings.valign > 1 then y = ScrH() - (y + h) end

  -- draw frame
  render.SetScissorRect(x, y, x + w, y + h, true)
  surface.SetAlphaMultiplier(alpha)
  draw.RoundedBox(8, x, y, w, h, self.colours.BgColor)
  draw.SimpleText(language.GetPhrase(settings.text), self.fonts.font, x + settings.text_xpos * scale, y + settings.text_ypos * scale, self.variables.AuxPowerColor)

  -- draw bar
  local segments = math.floor((w - inx * 2)/(chw + gap))
  for i=1, segments do
    surface.SetAlphaMultiplier(alpha * (settings.AuxPowerDisabledAlpha / 255))
    draw.RoundedBox(0, x + inx + math.floor(chw + gap) * (i - 1), y + iny, chw, bh, self.variables.AuxPowerColor)
    surface.SetAlphaMultiplier(alpha)
    if LocalPlayer():GetSuitPower() * .01 < i / segments then continue end
    draw.RoundedBox(0, x + inx + math.floor(chw + gap) * (i - 1), y + iny, chw, bh, self.variables.AuxPowerColor)
  end

  -- draw functions being used
  for i, label in pairs(labels) do
    draw.SimpleText(language.GetPhrase(label), self.fonts.font, x + settings.text2_xpos * scale, y + settings.text2_ypos * scale + settings.text2_gap * scale * (i - 1), self.variables.AuxPowerColor)
  end
  surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end
