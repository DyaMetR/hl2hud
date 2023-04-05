
local NET = HL2HUD.hookname .. '_pickup_full'

if SERVER then

  util.AddNetworkString(NET)

  local gmod_maxammo = GetConVar('gmod_maxammo')

  local PICKUP_DELAY = 2
  local CRATE_USE_DELAY = .75

  local ammoEnts = {
    item_ammo_357 = '357',
    item_ammo_357_large = '357',
    item_ammo_ar2 = 'AR2',
    item_ammo_ar2_altfire = 'AR2AltFire',
    item_ammo_ar2_large = 'AR2',
    item_ammo_crossbow = 'XBowBolt',
    item_ammo_pistol = 'Pistol',
    item_ammo_pistol_large = 'Pistol',
    item_ammo_smg1 = 'SMG1',
    item_ammo_smg1_grenade = 'SMG1_Grenade',
    item_ammo_smg1_large = 'SMG1',
    item_box_buckshot = 'Buckshot',
    item_rpg_round = 'RPG_Round'
  }

  local useEnt = {}

  --[[------------------------------------------------------------------
    Registers an entity class as an ammunition item.
    @param {string} entity class
    @param {string} ammunition name
  ]]--------------------------------------------------------------------
  function HL2HUD.AddAmmoItem(class, ammoType)
    ammoEnts[class] = ammoType
  end

  --[[------------------------------------------------------------------
    Returns whether a player has maxed out their ammo.
    @param {Player} player
    @param {number} ammunition ID
  ]]--------------------------------------------------------------------
  local function IsAmmoFull(_player, ammoType)
    local maxAmmo = gmod_maxammo:GetInt()
    if maxAmmo <= 0 then maxAmmo = game.GetAmmoMax(ammoType) end
    return _player:GetAmmoCount(ammoType) >= maxAmmo
  end

  --[[------------------------------------------------------------------
    Checks if the players is maxed out on the given ammo and sends the notice if so.
    @param {Player} player
    @param {string} ammunition name
  ]]--------------------------------------------------------------------
  local function SendAmmoDeniedMessage(_player, ammoType)
    if not IsAmmoFull(_player, game.GetAmmoID(ammoType)) then return end
    net.Start(NET)
    net.WriteString(ammoType)
    net.Send(_player)
  end

  -- [[ Initialize FULL message delay table ]] --
  hook.Add('PlayerInitialSpawn', NET, function(_player)
    if _player.HL2HUD_Full then return end
    _player.HL2HUD_Full = {}
  end)

  -- [[ Check whether the player is full on a weapon's ammunition ]] --
  hook.Add('PlayerCanPickupWeapon', NET, function(_player, weapon)
    if not IsValid(weapon) or weapon:GetPrimaryAmmoType() <= 0 then return end
    local ammoType = game.GetAmmoName(weapon:GetPrimaryAmmoType())
    if _player.HL2HUD_Full[ammoType] and _player.HL2HUD_Full[ammoType] > CurTime() then return end
    SendAmmoDeniedMessage(_player, ammoType)
    _player.HL2HUD_Full[ammoType] = CurTime() + PICKUP_DELAY
  end)

  -- [[ Check if the picked up item was an ammo box, and if the player is maxed out on its ammo ]] --
  hook.Add('PlayerCanPickupItem', NET, function(_player, item)
    if not IsValid(item) or not ammoEnts[item:GetClass()] then return end
    local ammoType = ammoEnts[item:GetClass()]
    if _player.HL2HUD_Full[ammoType] and _player.HL2HUD_Full[ammoType] > CurTime() then return end
    SendAmmoDeniedMessage(_player, ammoType)
    _player.HL2HUD_Full[ammoType] = CurTime() + PICKUP_DELAY
  end)

  -- [[ Check entities that give ammo when being used ]] --
  hook.Add('PlayerUse', NET, function(_player, ent)
    if not IsValid(_player) then return end
    local pressed = _player:KeyDown(IN_USE)
    if not IsValid(ent) or not useEnt[ent:GetClass()] or (_player.HL2HUD_UsePressed or not pressed) then return end
    useEnt[ent:GetClass()](_player, ent)
    _player.HL2HUD_UsePressed = pressed
  end)

  -- [[ Add buggy ammo crate check ]] --
  useEnt.prop_vehicle_jeep = function(_player, ent)
    local hitgroup = _player:GetEyeTrace().HitGroup
    if not hitgroup or hitgroup ~= 5 then return end
    SendAmmoDeniedMessage(_player, 'SMG1')
  end

  -- [[ Add ammo crate check ]] --
  local AMMO_CRATE = { 3, 4, 1, 8, 7, 10, 5, 6, 2, 9 }
  useEnt.item_ammo_crate = function(_player, ent)
    local ammoType = AMMO_CRATE[ent:GetInternalVariable('AmmoType') + 1]
    if not IsAmmoFull(_player, ammoType) then return end
    timer.Simple(CRATE_USE_DELAY, function()
      if not IsValid(_player) or not IsValid(ent) then return end
      SendAmmoDeniedMessage(_player, game.GetAmmoName(ammoType))
    end)
  end

end

if SERVER then return end

local HISTSLOT_EMPTY = 0
local HISTSLOT_AMMO = 1
local HISTSLOT_WEAP = 2
local HISTSLOT_ITEM = 3
local HISTSLOT_AMMODENIED = 4

local LOCALE_AMMO, LOCALE_ICON = 'ammo', 'icon'
local HEIGHT_CHAR = 'w'

local ELEMENT = HL2HUD.elements.Register('HudHistoryResource', 'CHudHistoryResource')

ELEMENT:Boolean('visible')
ELEMENT:Number('xpos')
ELEMENT:Number('ypos')
ELEMENT:Number('wide')
ELEMENT:Number('tall')
ELEMENT:Alignment('halign')
ELEMENT:Alignment('valign')
ELEMENT:Number('history_gap')
ELEMENT:Number('icon_inset')
ELEMENT:Number('text_inset')
ELEMENT:Font('NumberFont')
ELEMENT:Number('DrawHistoryTime')
ELEMENT:Colour('Color')
ELEMENT:Colour('EmptyWeaponColor')
ELEMENT:Font('TextFont')
ELEMENT:Colour('AmmoFullColor')
ELEMENT:String('AmmoFullText')
ELEMENT:Boolean('Episodic')
ELEMENT:Boolean('ShowMissingIcons')
ELEMENT:Font('MissingIconFont')

local m_PickupHistory = {}
local m_iCurrentHistorySlot = 0

--[[------------------------------------------------------------------
  If there aren't any items in the history, clear it out.
]]--------------------------------------------------------------------
local function CheckClearHistory()
  if table.Count(m_PickupHistory) > 0 then return end
  m_iCurrentHistorySlot = 0
  HL2HUD.animations.StartAnimationSequence('HintMessageRaise')
end

--[[------------------------------------------------------------------
  Adds an icon to the history.
  @param {HISTSLOT_} icon type
  @param {table} icon data
]]--------------------------------------------------------------------
local function AddIconToHistory(enum, data)
  local settings, scale = HL2HUD.settings.Get().HudLayout.HudHistoryResource, HL2HUD.Scale()
  local tall = ScrH() - (settings.ypos + settings.history_gap) * scale

  -- check to see if the pic would have to be drawn too high. If so, start again from the bottom
  if (settings.history_gap * scale) * (m_iCurrentHistorySlot + 1) > tall then m_iCurrentHistorySlot = 0 end

  -- if the history resource is appearing, slide the hint message element down
  if m_iCurrentHistorySlot == 0 then HL2HUD.animations.StartAnimationSequence('HintMessageLower') end

  -- add to tray
  data.type = enum
  data.time = data.time or CurTime() + settings.DrawHistoryTime
  m_PickupHistory[m_iCurrentHistorySlot] = data
  m_iCurrentHistorySlot = m_iCurrentHistorySlot + 1
end

--[[------------------------------------------------------------------
  Adds a weapon to the history.
  @param {Weapon} weapon to add
]]--------------------------------------------------------------------
local function AddWeaponToHistory(weapon)
  if not IsValid(weapon) then return end
  if not weapon:IsScripted() and not HL2HUD.settings.Get().HudTextures.Weapons[weapon:GetClass()] then return end
  local id = weapon:EntIndex()
  -- do not add this weapon if it already exists
  for _, icon in pairs(m_PickupHistory) do
    if icon.type ~= HISTSLOT_WEAP then continue end
    if icon.id == id then return end
  end
  AddIconToHistory(HISTSLOT_WEAP, { id = id, weapon = weapon })
end

--[[------------------------------------------------------------------
  Adds ammunition to the history.
  @param {string} ammunition type
  @param {number} amount added
]]--------------------------------------------------------------------
local function AddAmmoToHistory(ammo, count)
  -- clear out any ammo pickup denied icons, since we can obviously pickup again
  for i, icon in pairs(m_PickupHistory) do
    if icon.type == HISTSLOT_AMMODENIED and icon.id == ammo then
      m_PickupHistory[m_iCurrentHistorySlot] = nil
      m_iCurrentHistorySlot = i
      break
    end
  end
  AddIconToHistory(HISTSLOT_AMMO, { id = ammo, count = count })
end

--[[------------------------------------------------------------------
  Adds ammunition pickup denial to the history.
  @param {string} ammunition type
]]--------------------------------------------------------------------
local function AddAmmoDeniedToHistory(ammo)
  -- see if there are any denied ammo icons, if so refresh their timer
  for i, icon in pairs(m_PickupHistory) do
    if icon.type == HISTSLOT_AMMODENIED and icon.id == ammo then
      icon.time = CurTime() + HL2HUD.settings.Get().HudLayout.HudHistoryResource.DrawHistoryTime * .5
      return
    end
  end
  AddIconToHistory(HISTSLOT_AMMODENIED, { id = ammo })
end

--[[------------------------------------------------------------------
  Adds an item to the history.
  @param {string} item class
]]--------------------------------------------------------------------
local function AddItemToHistory(class)
  AddIconToHistory(HISTSLOT_ITEM, { id = class })
end

function ELEMENT:ShouldDraw(settings)
  return settings.visible
end

function ELEMENT:OnThink(settings)
  for i, icon in pairs(m_PickupHistory) do
    if icon.time > CurTime() then continue end
    m_PickupHistory[i] = nil
    CheckClearHistory()
  end
end

function ELEMENT:Draw(settings, scale)
  local database = HL2HUD.settings.Get().HudTextures
  local x, y = settings.xpos * scale, settings.ypos * scale
  local w, h = settings.wide * scale, settings.tall * scale
  if settings.halign > 1 then x = ScrW() - (x + w) end
  if settings.valign > 1 then y = ScrH() - (y + h) end
  for i, pickup in pairs(m_PickupHistory) do
    local colour = self.colours[settings.Color]
    local xpos, ypos = x + w - settings.icon_inset * scale, y + h - settings.history_gap * i * scale
    surface.SetAlphaMultiplier(math.max((pickup.time - CurTime()) * 80, 0) / 255)
    if pickup.type == HISTSLOT_WEAP then
      if not IsValid(pickup.weapon) then continue end
      local icon = database.Weapons[pickup.weapon:GetClass()]
      if not icon then
        if not pickup.weapon:IsScripted() then continue end
        local bounce = pickup.weapon.BounceWeaponIcon
        local info = pickup.weapon.DrawWeaponInfoBox
        pickup.weapon.BounceWeaponIcon = false
        pickup.weapon.DrawWeaponInfoBox = false
        pickup.weapon:DrawWeaponSelection(xpos - 112 * scale, ypos, 112 * scale, 80 * scale, 255)
        pickup.weapon.BounceWeaponIcon = bounce
        pickup.weapon.DrawWeaponInfoBox = info
        continue
      end
      if not pickup.weapon:HasAmmo() then colour = self.colours[settings.EmptyWeaponColor] end
      HL2HUD.utils.DrawIcon(icon, xpos, ypos, colour, TEXT_ALIGN_RIGHT)
    elseif pickup.type == HISTSLOT_AMMO or pickup.type == HISTSLOT_AMMODENIED then
      local icon = database.Ammo[pickup.id]
      if not settings.ShowMissingIcons and not icon then continue end
      local text, font = pickup.count, self.fonts.NumberFont
      if pickup.type == HISTSLOT_AMMODENIED then
        colour = self.colours[settings.AmmoFullColor]
        text = language.GetPhrase(settings.AmmoFullText)
        font = self.fonts.TextFont
      else
        local wepIco = database.AmmoWep[pickup.id]
        if settings.Episodic and wepIco then
          local icoW, icoH = HL2HUD.utils.GetIconSize(wepIco)
          HL2HUD.utils.DrawIcon(wepIco, xpos, ypos + icoH * .5, colour, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
          xpos = xpos - icoW * 1.25
        end
      end
      if icon then
        local _, icoH = HL2HUD.utils.GetIconSize(icon)
        HL2HUD.utils.DrawIcon(icon, xpos, ypos, colour, TEXT_ALIGN_RIGHT)
        ypos = ypos + icoH * .5
      else
        surface.SetFont(self.fonts.MissingIconFont)

        -- get margins
        local _, fontH = surface.GetTextSize(HEIGHT_CHAR)
        fontH = fontH - 2.6 * scale

        -- get length
        local name = string.lower(pickup.id)
        local icoW, nameW = surface.GetTextSize(LOCALE_AMMO), surface.GetTextSize(name)
        if nameW > icoW then icoW = nameW end
        xpos = xpos - icoW * .5

        -- draw fake icon
        draw.SimpleText(name, self.fonts.MissingIconFont, xpos, ypos - fontH, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(LOCALE_AMMO, self.fonts.MissingIconFont, xpos, ypos, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(LOCALE_ICON, self.fonts.MissingIconFont, xpos, ypos + fontH, colour, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      end
      draw.SimpleText(text, font, x + w - settings.text_inset * scale, ypos, colour, nil, TEXT_ALIGN_CENTER)
    elseif pickup.type == HISTSLOT_ITEM then
      local icon = database.Entities[pickup.id]
      if not icon then continue end
      HL2HUD.utils.DrawIcon(icon, xpos, ypos, colour, TEXT_ALIGN_RIGHT)
    end
  end
  surface.SetAlphaMultiplier(1)
end

-- [[ Helper function to determine whether the element is visible ]] --
local function IsEnabled() return GetConVar('hl2hud_enabled'):GetBool() and HL2HUD.settings.Get().HudLayout.HudHistoryResource.visible end

-- [[ Ammo picked up ]] --
hook.Add('HUDAmmoPickedUp', HL2HUD.hookname, function(ammo, amount)
  if not IsEnabled() then return end
  AddAmmoToHistory(ammo, amount)
end)

-- [[ Weapon picked up ]] --
hook.Add('HUDWeaponPickedUp', HL2HUD.hookname, function(weapon)
  if not IsEnabled() then return end
  AddWeaponToHistory(weapon)
end)

-- [[ Item picked up ]] --
hook.Add('HUDItemPickedUp', HL2HUD.hookname, function(class)
  if not IsEnabled() then return end
  AddItemToHistory(class)
end)

-- [[ Hide default pickup history ]] --
hook.Add('HUDDrawPickupHistory', HL2HUD.hookname, function()
  if not IsEnabled() then return end
  return false
end)

-- [[ Receive an ammunition pickup denial notice ]] --
net.Receive(NET, function()
  AddAmmoDeniedToHistory(net.ReadString())
end)
