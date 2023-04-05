--[[------------------------------------------------------------------
  DyaMetR's weapon switcher script
  September 19th, 2021
  API to be used in a custom weapon selector.
]]--------------------------------------------------------------------

if SERVER then return end

HL2HUD.switcher = {} -- namespace

-- Configuration
local MAX_SLOTS = 6 -- maximum number of weapon slots

-- Constants
local PHYSICS_GUN = 'weapon_physgun'
local SLOT, INV_PREV, INV_NEXT, ATTACK, ATTACK2, LAST_INV = 'slot', 'invprev', 'invnext', '+attack', '+attack2', 'lastinv'
local VOLUME = .33

-- Variables
local curSlot = 0 -- current slot selected
local curPos = 0 -- current weapon position selected
local weaponCount = 0 -- current weapon count
local cache = {} -- cached weapons sorted per slot
local cacheLength = {} -- how many weapons are there in each slot
local weaponPos = {} -- assigned table position in slot
local weaponList = {} -- list of cached weapons

-- Initialize cache
for slot = 1, MAX_SLOTS do
  cache[slot] = {}
  cacheLength[slot] = 0
end

--[[------------------------------------------------------------------
  Whether empty weapons should be skipped by the selector
  @param {Weapon} weapon to check
  @return {boolean} skip
]]--------------------------------------------------------------------
local function skipEmpty(weapon)
  return HL2HUD.settings.Get().HudLayout.HudWeaponSelection.SkipEmpty
end

--[[------------------------------------------------------------------
  Sorting function to order a weapon inventory slot by slot position
  @param {Weapon} a
  @param {Weapon} b
]]--------------------------------------------------------------------
local function sortWeaponSlot(a, b)
  return a:GetSlotPos() < b:GetSlotPos()
end

--[[------------------------------------------------------------------
  Helper function to determine whether the weapon selector is visible.
  @return {boolean} is it visible
]]--------------------------------------------------------------------
local function isOpen()
  return HL2HUD.elements.Get('HudWeaponSelection').variables.Alpha > 0
end

--[[------------------------------------------------------------------
  Caches the current weapons the player has
  @param {boolean} force update
]]--------------------------------------------------------------------
local function cacheWeapons(force)
  -- get current weapons
  local weapons = LocalPlayer():GetWeapons()

  -- only cache when weapon count is different
  if not force and weaponCount == #weapons then
    local shouldCache = false

    -- check if there was a bait and switch in any moment
    for _, weapon in pairs(weapons) do
      if not weaponList[weapon] then
        shouldCache = true
        break
      end
    end

    -- if nothing weird was found, do not update
    if not shouldCache then return end
  end

  -- reset cache
  for slot = 1, MAX_SLOTS do
    for pos = 0, cacheLength[slot] do
      cache[slot][pos] = nil
    end
    cacheLength[slot] = 0
  end
  table.Empty(weaponPos)

  -- update weapon count
  weaponCount = #weapons
  table.Empty(weaponList)

  -- add weapons
  for _, weapon in pairs(weapons) do
    -- weapon slots start at 0, so we need to make it start at 1 because of lua tables
    local slot = math.min(weapon:GetSlot() + 1, MAX_SLOTS)

    -- do not add if the slot is out of bounds
    if slot <= 0 then continue end

    -- cache weapon
    table.insert(cache[slot], weapon)
    cacheLength[slot] = cacheLength[slot] + 1
    weaponList[weapon] = true
  end

  -- sort slots
  for slot = 1, MAX_SLOTS do
    table.sort(cache[slot], sortWeaponSlot)

    -- get sorted weapons' positions
    for pos, weapon in pairs(cache[slot]) do
      weaponPos[weapon] = pos
    end
  end

  -- check whether we're out of bounds
  if curSlot > 0 then
    if weaponCount <= 0 then
      curSlot = 0
      curPos = 1
    else
      curPos = math.min(curPos, cacheLength[curSlot])
    end
  end
end
HL2HUD.switcher.CacheWeapons = cacheWeapons

--[[------------------------------------------------------------------
  Finds the next slot with weapons
  @param {number} starting slot
  @param {boolean} move forward
  @return {number} slot found
]]--------------------------------------------------------------------
local function findSlot(slot, forward)
  -- do not search if there are no weapons
  if weaponCount <= 0 then return slot end

  -- otherwise, search for the next slot with weapons
  while (not cacheLength[slot] or cacheLength[slot] <= 0) do
    if forward then
      if slot < MAX_SLOTS then
        slot = slot + 1
      else
        slot = 1
      end
    else
      if slot > 1 then
        slot = slot - 1
      else
        slot = MAX_SLOTS
      end
    end
  end

  return slot
end

--[[------------------------------------------------------------------
  Finds the next weapon with ammo to select
  @param {number} starting slot
  @param {number} starting slot position
  @param {boolean} move forward
  @param {boolean} move only inside the given slot
  @return {number} slot found
  @return {number} slot position found
]]--------------------------------------------------------------------
local function findWeapon(slot, pos, forward, inSlot)
  -- do not search if there are no weapons
  if weaponCount <= 0 then return slot, pos end

  -- otherwise, search for the next weapon with ammo
  local weapons = #LocalPlayer():GetWeapons() -- current weapon count
  local noAmmo = 0 -- weapons with no ammunition left
  local weapon
  while (not weapon or not IsValid(weapon) or (not weapon:HasAmmo() and skipEmpty(weapon))) do
    -- look for the next weapon
    if forward then
      if pos < cacheLength[slot] then
        pos = pos + 1
      else
        pos = 1

        -- find next slot
        if not inSlot then
          slot = findSlot(slot + 1, true)
        end
      end
      weapon = cache[slot][pos] -- update current weapon
    else
      if pos > 1 then
        pos = pos - 1
      else
        -- find next slot
        if not inSlot then
          slot = findSlot(slot - 1, false)
        end

        pos = cacheLength[slot]
      end
      weapon = cache[slot][pos] -- update current weapon
    end

    -- add to no ammo list
    if skipEmpty(weapon) and (not IsValid(weapon) or not weapon:HasAmmo()) then noAmmo = noAmmo + 1 end

    -- check whether all weapons are empty to stop search
    if noAmmo >= weapons then break end
  end

  -- if there are no weapons with ammo, show the selector empty
  if noAmmo >= weapons then pos = 0 end

  return slot, pos
end

--[[------------------------------------------------------------------
  Moves the cursor one position going to across all slots
  @param {boolean} move forward
]]--------------------------------------------------------------------
local function moveCursor(forward)
  -- do not move cursor if there are no weapons to cycle through
  if weaponCount <= 0 then return end

  -- if slot is out of bounds, get the current weapon's
  if curSlot <= 0 or not isOpen() then
    local weapon = LocalPlayer():GetActiveWeapon()

    -- if there are no weapons equipped, start at the first slot
    if IsValid(weapon) then
      -- make sure weapon is on the cache
      if not weaponPos[weapon] then
        cacheWeapons(true)
      end

      -- get weapon information
      curSlot = math.min(weapon:GetSlot() + 1, MAX_SLOTS)
      curPos = weaponPos[weapon]
    else
      curSlot = 1
      curPos = 0
    end
  end

  -- move cursor
  curSlot, curPos = findWeapon(curSlot, curPos, forward)
end

--[[------------------------------------------------------------------
  Moves the cursor inside a slot
  @param {number} slot
]]--------------------------------------------------------------------
local function cycleSlot(slot)
  -- do not move cursor if there are no weapons to cycle through
  if cacheLength[slot] <= 0 then
    curSlot = slot
    curPos = 0
    return
  end

  -- position to search from
  local pos = curPos

  -- if slot is new, start from the beginning
  if curSlot ~= slot or not isOpen() then pos = 0 end

  -- search for weapon
  curSlot, curPos = findWeapon(slot, pos, true, true)
end

--[[------------------------------------------------------------------
  Selects the weapon highlighted in the switcher
]]--------------------------------------------------------------------
local function equipSelectedWeapon()
  local weapon = cache[curSlot][curPos]
  if not weapon or not IsValid(weapon) then return end
  input.SelectWeapon(weapon)
end

--[[------------------------------------------------------------------
  Exports the weapon selector status.
  @return {number} selected slot
  @return {number} selected slot position
  @return {table} cached weapons
  @return {table} cached weapons' length
]]--------------------------------------------------------------------
function HL2HUD.switcher.Import()
  return curSlot, curPos, cache, cacheLength
end

-- [[ Input ]] --
local hud_fastswitch = GetConVar('hud_fastswitch')
UnintrusiveBindPress.add('hl2hud', function(_player, bind, pressed, code)
  if not HL2HUD.ShouldDraw() then return end -- don't do anything if HUD is disabled
  if not HL2HUD.elements.Get('HudWeaponSelection'):ShouldDraw(HL2HUD.settings.Get().HudLayout.HudWeaponSelection) then return end -- does the element want to be drawn?
  if hud_fastswitch:GetBool() then return end -- let fast switch do its thing
  if weaponCount <= 0 or not LocalPlayer():Alive() or LocalPlayer():InVehicle() then return end -- ignore if player has no weapons, is dead or in a vehicle
  if not pressed then return end -- ignore if bind was not pressed
  local visible = HL2HUD.elements.Get('HudWeaponSelection').variables.Alpha > 0

  -- check whether the physics gun is in use
  local weapon = LocalPlayer():GetActiveWeapon()
  if IsValid(weapon) and weapon:GetClass() == PHYSICS_GUN and LocalPlayer():KeyDown(IN_ATTACK) and (bind == INV_PREV or bind == INV_NEXT) then return true end
  local settings = HL2HUD.settings.Get().HudLayout.HudWeaponSelection

  -- move backwards
  if bind == INV_PREV then
    LocalPlayer():EmitSound(settings.MoveSnd, SNDLVL_NONE, nil, VOLUME, CHAN_ITEM)
    moveCursor(false)
    if curPos <= 0 then return true end -- do not show if there is no valid slot
    HL2HUD.animations.StartAnimationSequence('OpenWeaponSelectionMenu')
    return true
  end

  -- move forward
  if bind == INV_NEXT then
    LocalPlayer():EmitSound(settings.MoveSnd, SNDLVL_NONE, nil, VOLUME, CHAN_ITEM)
    moveCursor(true)
    if curPos <= 0  then return true end -- do not show if there is no valid slot
    HL2HUD.animations.StartAnimationSequence('OpenWeaponSelectionMenu')
    return true
  end

  -- last weapon
  if bind == LAST_INV then
    local lastWeapon = LocalPlayer():GetPreviousWeapon()
    if IsValid(lastWeapon) and lastWeapon:IsWeapon() then
      input.SelectWeapon(lastWeapon)
    end
  end

  -- cycle through slot
  if string.sub(bind, 1, 4) == SLOT then
    local slot = tonumber(string.sub(bind, 5))

    -- ignore if we go out of bounds
    if slot > 0 and slot <= MAX_SLOTS then
      LocalPlayer():EmitSound(settings.MoveSnd, SNDLVL_NONE, nil, VOLUME, CHAN_ITEM)
      if cacheLength[slot] <= 0 then return true end -- do not show if slot is empty
      cycleSlot(slot)
      HL2HUD.animations.StartAnimationSequence('OpenWeaponSelectionMenu')
      return true
    end
  end

  -- select
  if visible and (bind == ATTACK or bind == ATTACK2) then
    equipSelectedWeapon()
    HL2HUD.animations.StartAnimationSequence('CloseWeaponSelectionMenu')
    LocalPlayer():EmitSound(settings.SelectSnd, SNDLVL_NONE, nil, VOLUME, CHAN_ITEM)
    return true
  end
end)
