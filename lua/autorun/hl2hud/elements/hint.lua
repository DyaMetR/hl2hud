
if SERVER then

  local HOOK = HL2HUD.hookname .. '_hudhint'

  util.AddNetworkString(HOOK)

  local weapons = { -- weapon hints
    weapon_smg1 = '#Valve_Hint_Alt_Weapon_SMG1',
    weapon_crossbow = '#Valve_Hint_Alt_Weapon_Crossbow',
    weapon_ar2 = '#Valve_Hint_Alt_Weapon_AR2',
    weapon_shotgun = '#Valve_Hint_Alt_Weapon_Shotgun',
    weapon_frag = '#Valve_Hint_Alt_Weapon_Frag',
    weapon_bugbait = '#Valve_Hint_Alt_Weapon_Bugbait',
    weapon_physcannon = '#Valve_Hint_Alt_Weapon_Physcannon'
  }

  local vehicles = { -- vehicle controls hints
    prop_vehicle_jeep = '#Valve_Hint_JeepKeys',
    prop_vehicle_airboat = '#Valve_Hint_BoatKeys'
  }

  --[[------------------------------------------------------------------
    Adds a hint to display to the player after picking up a certain weapon.
    @param {string} weapon class
    @param {string} hint to display
  ]]--------------------------------------------------------------------
  function HL2HUD.AddWeaponHint(class, hint)
    weapons[class] = hint
  end

  --[[------------------------------------------------------------------
    Adds a hint to display to the player after entering a certain vehicle.
    @param {string} vehicle class
    @param {string} hint to display
  ]]--------------------------------------------------------------------
  function HL2HUD.AddVehicleHint(class, hint)
    vehicles[class] = hint
  end


  --[[------------------------------------------------------------------
    Sends a HUD hint to the given player.
    @param {string} hint text
    @param {CRecipientFilter} player or players
    @param {boolean|nil} can be ignored by the 'minimal hints' console variable
  ]]--------------------------------------------------------------------
  function HL2HUD.SendHint(hint, _player, skippable)
    if not hint then return end
    net.Start(HOOK)
    net.WriteBool(true)
    net.WriteString(hint)
    net.WriteBool(skippable or false)
    net.Send(_player)
  end

  --[[------------------------------------------------------------------
    Makes the player hide their current hint.
    @param {CRecipientFilter} player or players
  ]]--------------------------------------------------------------------
  function HL2HUD.HideHint(_player)
    net.Start(HOOK)
    net.WriteBool(false)
    net.Send(_player)
  end

  --[[------------------------------------------------------------------
    Sends a hint if it hasn't been displayed to the player yet.
    @param {string} hint
    @param {Player} player to send hint to
    @param {number} delay
    @param {boolean|nil} can be ignored by the 'minimal hints' console variable
  ]]--------------------------------------------------------------------
  function HL2HUD.SendHintOnce(hint, _player, delay, skippable)
    if not hint then return end
    if istable(_player) then
      for _, member in pairs(_player) do
        HL2HUD.SendHintOnce(hint, member)
      end
      return
    end
    if not _player.HL2HUD_HintOnce then _player.HL2HUD_HintOnce = {} end
    if _player.HL2HUD_HintOnce[hint] then return end
    timer.Simple(delay or 0, function()
      if not IsValid(_player) then return end
      HL2HUD.SendHint(hint, _player, skippable)
    end)
    _player.HL2HUD_HintOnce[hint] = true
  end

  -- [[ Receive hint from trigger ]] --
  local ENT_CLASS, IN_SHOW = 'env_hudhint', 'ShowHudHint'
  hook.Add('AcceptInput', HOOK, function(ent, input, activator)
    if ent:GetClass() ~= ENT_CLASS then return end
    local filter = activator
    if not activator:IsPlayer() then filter = player.GetAll() end
    if input == IN_SHOW then
      HL2HUD.SendHint(ent.m_iszMessage, filter)
    else
      HL2HUD.HideHint(filter)
    end
  end)

  -- [[ Show a hint when using a weapon for the first time ]] --
  hook.Add('PlayerSwitchWeapon', HOOK, function(_player, _, weapon)
    if not IsValid(weapon) then return end
    local class = weapon:GetClass()
    if not weapons[class] then return end
    HL2HUD.SendHintOnce(weapons[class], _player, 6, true)
  end)

  -- [[ Show a hint when entering a vehicle for the first time ]] --
  hook.Add('PlayerEnteredVehicle', HOOK, function(_player, vehicle, role)
    if not IsValid(vehicle) then return end
    local class = vehicle:GetClass()
    if not vehicles[class] then return end
    HL2HUD.SendHintOnce(vehicles[class], _player, 2, true)
  end)

end

if SERVER then return end

local hl2hud_minimalhints = CreateClientConVar('hl2hud_minimalhints', 1, true)

local ELEMENT = HL2HUD.elements.Register('HudHintDisplay', 'CHudHintDisplay')

ELEMENT:Boolean('visible')
ELEMENT:Number('xpos')
ELEMENT:Number('ypos')
ELEMENT:Alignment('halign')
ELEMENT:Alignment('valign')
ELEMENT:Number('text_xpos')
ELEMENT:Number('text_ypos')
ELEMENT:Number('text_xgap')
ELEMENT:Number('text_ygap')
ELEMENT:Font('bind_font')
ELEMENT:Font('text_font')

local hints = {
  hints = {},
  bind = '',
  hint = ''
}

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

function ELEMENT:Init()
  self:Variable('BgColor', table.Copy(self.colours.BgColor))
  self:Variable('FgColor', table.Copy(self.colours.FgColor))
  self:Variable('Position', Vector(0, 0))
  self:Variable('Alpha', 0)
end

function ELEMENT:Draw(settings, scale)
  if table.IsEmpty(hints) or self.variables.Alpha <= 0 then return end
  surface.SetFont(self.fonts.bind_font)
  local margin, tall = surface.GetTextSize(hints.bind)
  surface.SetFont(self.fonts.text_font)
  local length = surface.GetTextSize(hints.hint)
  local x, y = (settings.xpos + self.variables.Position.x) * scale, (settings.ypos + self.variables.Position.y) * scale
  local w, h = (settings.text_xgap * 3 * scale) + margin + length, (settings.text_ygap * (math.max(#hints.hints - 1, 0) + 2)) * scale + tall * #hints.hints
  local align
  if settings.halign > 1 then x = ScrW() - (x + w) end
  if settings.valign > 1 then y = ScrH() - (y + h) end
  render.SetScissorRect(x, y, x + w, y + h, true)
  surface.SetAlphaMultiplier(math.max(self.variables.Alpha / 255, 0))
  draw.RoundedBox(8, x, y, w, h, self.variables.BgColor)
  for _, hint in pairs(hints.hints) do
    draw.SimpleText(hint.bind, self.fonts.bind_font, x + settings.text_xpos * scale, y + settings.text_ypos * scale, self.variables.FgColor)
    local gap = settings.text_xgap
    if string.len(hint.bind) <= 0 then gap = 0 end
    draw.SimpleText(hint.hint, self.fonts.text_font, x + margin + (settings.text_xpos + gap) * scale, y + tall * .5 + settings.text_ypos * scale, self.variables.FgColor, nil, TEXT_ALIGN_CENTER)
    y = y + tall + settings.text_ygap * scale
  end
  surface.SetAlphaMultiplier(1)
  render.SetScissorRect(0, 0, 0, 0, false)
end

--[[------------------------------------------------------------------
  Parses the given string into different hints.
  We have to do this by hand since apparently Lua patterns don't support accented characters (and potentially other alphabets either).
  @param {string} raw string
  @return {table} parsed hints
]]--------------------------------------------------------------------
local BIND_MATCH = '%%%g+%%'
local SPACE, NEXT_LINE = ' ', '\n'
local function parseHints(raw)
  table.Empty(hints.hints) -- reset hints
  hints.bind = '' -- reset longest bind
  hints.hint = '' -- reset longest hint message
  local binds = {}
  for bind in string.gmatch(raw, BIND_MATCH) do
    raw = string.Replace(raw, SPACE .. bind, NEXT_LINE .. bind)
    table.insert(binds, bind)
  end
  for i, line in pairs(string.Split(raw, NEXT_LINE)) do
    local bind, desc = '', line
    local matched = binds[i]
    if matched then
      bind = input.LookupBinding(string.sub(matched, 2, string.len(matched) - 1))
      desc = string.sub(line, string.len(matched) + 1)
    end
    local hint = { bind = string.upper(bind or ""), hint = desc }
    table.insert(hints.hints, hint)
    if string.len(hint.bind) > string.len(hints.bind) then hints.bind = hint.bind end
    if string.len(hint.hint) > string.len(hints.hint) then hints.hint = hint.hint end
  end
end

-- [[ Receive signals ]] --
net.Receive(HL2HUD.hookname .. '_hudhint', function()
  if net.ReadBool() then
    local hint, skippable = net.ReadString(), net.ReadBool()
    if hl2hud_minimalhints:GetBool() and skippable then return end
    parseHints(language.GetPhrase(hint))
    HL2HUD.animations.StartAnimationSequence('HintMessageShow')
  else
    HL2HUD.animations.StartAnimationSequence('HintMessageHide')
  end
end)
