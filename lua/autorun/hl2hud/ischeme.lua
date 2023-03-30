--[[------------------------------------------------------------------
  Schemes API.

  > SCHEME functions
    - These are used to shape up the scheme.

  > HL2HUD.scheme.Register(name, scheme)
    - Registers a new scheme.
]]--------------------------------------------------------------------

if SERVER then return end

HL2HUD.scheme = { -- namespace
  ICON_FONT = 1,
  ICON_SPRITE = 2,
  ICON_FORMAT = 'hl2hud_icons_%s'
}

local DATA_TABLE = { -- blank scheme data structure
  HudLayout = {},
  HudAnimations = {},
  HudTextures = {
    Weapons = {},
    Selected = {},
    Entities = {},
    AmmoInv = {},
    Ammo = {},
    AmmoWep = {}
  },
  ClientScheme = {
    Colors = {},
    Fonts = {}
  }
}

local schemes = {} -- registered presets
local parse = {} -- animation commands parse functions

local SCHEME = { settings = table.Copy(DATA_TABLE) }

--[[------------------------------------------------------------------
  Parses an animation command and returns its result.
  @param {table} command
  @return {table} translated
]]--------------------------------------------------------------------
local function ParseCommand(cmd)
  if cmd[1] == 'Animate' then
    local startTime, duration = 6, 7
    local command = { commandType = cmd[1], panel = cmd[2], variable = cmd[3], target = cmd[4], interpolator = cmd[5] }
    if #cmd > 7 then
      command.interpolatorParam = cmd[6]
      startTime = 7
      duration = 8
    end
    command.startTime = cmd[startTime]
    command.duration = cmd[duration]
    return command
  else
    local command = { commandType = cmd[1], param = cmd[2], startTime = cmd[#cmd] }
    if #cmd >= 4 then command.param2 = cmd[3] end
    return command
  end
end

--[[------------------------------------------------------------------
  Adds a selectable font.
  @param {string} name
  @param {string} font family
  @param {number} size
  @param {number} weight
  @param {boolean} additive
  @param {number} blur size
  @param {number} scanlines margin
  @param {boolean} is symbolic font
  @param {boolean} scalable
  @param {boolean} antialias
]]--------------------------------------------------------------------
function SCHEME:Font(name, font, size, weight, additive, blur, scanlines, symbol, scalable, antialias)
  if scalable == nil then scalable = true end
  if antialias == nil then antialias = true end
  self.settings.ClientScheme.Fonts[name] = {
    font = font,
    size = size,
    weight = weight,
    additive = additive,
    blur = blur,
    scanlines = scanlines,
    symbol = symbol,
    scalable = scalable,
    antialias = antialias
  }
end

--[[------------------------------------------------------------------
  Adds a selectable colour.
  @param {string} name
  @param {Color} colour
]]--------------------------------------------------------------------
function SCHEME:Colour(name, colour)
  self.settings.ClientScheme.Colors[name] = colour
end

--[[------------------------------------------------------------------
  Sets the colour table.
  @param {table} colours
]]--------------------------------------------------------------------
function SCHEME:Scheme(colours)
  table.Merge(self.settings.ClientScheme.Colors, colours)
end

--[[------------------------------------------------------------------
  Sets an element's parameter value.
  @param {string} element
  @param {string} parameter
  @param {any} value
]]--------------------------------------------------------------------
function SCHEME:Parameter(element, parameter, value)
  if not self.settings.HudLayout[element] then self.settings.HudLayout[element] = {} end
  self.settings.HudLayout[element][parameter] = value
end

--[[------------------------------------------------------------------
  Sets the parameters of an element.
  @param {string} element
  @param {table} parameters
]]--------------------------------------------------------------------
function SCHEME:Element(element, parameters)
  table.Merge(self.settings.HudLayout[element], parameters)
end

--[[------------------------------------------------------------------
  Sets the parameter table.
  @param {table} elements' parameters
]]--------------------------------------------------------------------
function SCHEME:Layout(layout)
  table.Merge(self.settings.HudLayout, layout)
end

--[[------------------------------------------------------------------
  Sets the weapon selector icons table.
  @param {table} weapon icons
]]--------------------------------------------------------------------
function SCHEME:WeaponIcons(icons)
  table.Merge(self.settings.HudTextures.Weapons, icons)
end

--[[------------------------------------------------------------------
  Sets the weapon selector highlighted icons table.
  @param {table} weapon icons
]]--------------------------------------------------------------------
function SCHEME:SelectedWeaponIcons(icons)
  table.Merge(self.settings.HudTextures.Selected, icons)
end

--[[------------------------------------------------------------------
  Sets the ammo indicator icons table.
  @param {table} ammo icons
]]--------------------------------------------------------------------
function SCHEME:AmmoIcons(icons)
  table.Merge(self.settings.HudTextures.AmmoInv, icons)
end

--[[------------------------------------------------------------------
  Sets the ammo pickup icons table.
  @param {table} ammo icons
]]--------------------------------------------------------------------
function SCHEME:AmmoPickups(icons)
  table.Merge(self.settings.HudTextures.Ammo, icons)
end

--[[------------------------------------------------------------------
  Adds a font based icon.
  @param {table} icon list to add to
  @param {string} related ID/entity class
  @param {string} font
  @param {string} icon character
  @param {number|nil} x offset
  @param {number|nil} y offset
  @return {table} generated icon data
]]--------------------------------------------------------------------
function SCHEME:AddIcon(tbl, class, font, icon, x, y)
  x = x or 0
  y = y or 0
  local data = { type = HL2HUD.scheme.ICON_FONT, font = font, icon = icon, x = x, y = y }
  tbl[class] = data
  return data
end

--[[------------------------------------------------------------------
  Adds a font based icon.
  @param {table} icon list to add to
  @param {string} related ID/entity class
  @param {number} texture ID
  @param {number} texture file width
  @param {number} texture file height
  @param {number} left u coordinate
  @param {number} top v coordinate
  @param {number} right u coordinate
  @param {number} bottom v coordinate
  @param {number|nil} x offset
  @param {number|nil} y offset
  @param {boolean|nil} is it scalable
  @return {table} generated icon data
]]--------------------------------------------------------------------
function SCHEME:AddSprite(tbl, class, texture, w, h, u1, v1, u2, v2, x, y, scalable)
  if scalable == nil then scalable = true end
  x = x or 0
  y = y or 0
  local data = { type = HL2HUD.scheme.ICON_SPRITE, texture = texture, w = w, h = h, u1 = u1, v1 = v1, u2 = u2, v2 = v2, x = x, y = y, scalable = scalable }
  tbl[class] = data
  return data
end

--[[------------------------------------------------------------------
  Adds a selected weapon selector icon.
  @param {string} weapon class
  @param {string} scheme font
  @param {string} character
  @param {number|nil} x offset
  @param {number|nil} y offset
]]--------------------------------------------------------------------
function SCHEME:WeaponSelectedIcon(weapon, font, icon, x, y)
  self:AddIcon(self.settings.HudTextures.Selected, weapon, font, icon, x, y)
end

--[[------------------------------------------------------------------
  Adds an weapon selector icon.
  @param {string} weapon class
  @param {string} font
  @param {string} character
  @param {string} selected icon font
  @param {string|nil} selected icon character
  @param {number|nil} x offset
  @param {number|nil} y offset
]]--------------------------------------------------------------------
function SCHEME:WeaponIcon(weapon, font, icon, font2, icon2, x, y)
  self:AddIcon(self.settings.HudTextures.Weapons, weapon, font, icon, x, y)
  if font2 then self:WeaponSelectedIcon(weapon, font2, icon2 or icon, x, y) end
end

--[[------------------------------------------------------------------
  Removes a weapon icon.
  @param {string} weapon class
]]--------------------------------------------------------------------
function SCHEME:RemoveWeaponIcon(weapon)
  self.settings.HudTextures.Weapons[weapon] = -1
end

--[[------------------------------------------------------------------
  Adds a sprite as a weapon selector icon.
  @param {string} weapon class
  @param {number} texture ID
  @param {number} texture file width
  @param {number} texture file height
  @param {number} left u coordinate
  @param {number} top v coordinate
  @param {number} right u coordinate
  @param {number} bottom v coordinate
  @param {number|nil} x offset
  @param {number|nil} y offset
  @param {boolean|nil} is it scalable
]]--------------------------------------------------------------------
function SCHEME:WeaponSprite(weapon, texture, w, h, u1, v1, u2, v2, x, y, scalable)
  self:AddSprite(self.settings.HudTextures.Weapons, weapon, texture, w, h, u1, v1, u2, v2, x, y, scalable)
end

--[[------------------------------------------------------------------
  Adds a sprite as a selected weapon selector icon.
  @param {string} weapon class
  @param {number} texture ID
  @param {number} texture file width
  @param {number} texture file height
  @param {number} left u coordinate
  @param {number} top v coordinate
  @param {number} right u coordinate
  @param {number} bottom v coordinate
  @param {number|nil} x offset
  @param {number|nil} y offset
  @param {boolean|nil} is it scalable
]]--------------------------------------------------------------------
function SCHEME:WeaponSelectedSprite(weapon, texture, w, h, u1, v1, u2, v2, x, y, scalable)
  self:AddSprite(self.settings.HudTextures.Selected, weapon, texture, w, h, u1, v1, u2, v2, x, y, scalable)
end

--[[------------------------------------------------------------------
  Removes a selected weapon icon.
  @param {string} weapon class
]]--------------------------------------------------------------------
function SCHEME:RemoveSelectedWeaponIcon(weapon)
  self.settings.HudTextures.Selected[weapon] = -1
end

--[[------------------------------------------------------------------
  Adds an ammunition icon shown in the ammunition indicator.
  @param {string} ammunition name
  @param {string} scheme font
  @param {string} character
  @param {number|nil} x offset
  @param {number|nil} y offset
]]--------------------------------------------------------------------
function SCHEME:AmmoIcon(ammo, font, icon, x, y)
  self:AddIcon(self.settings.HudTextures.AmmoInv, ammo, font, icon, x, y)
end

--[[------------------------------------------------------------------
  Adds an ammunition icon shown in the ammunition indicator.
  @param {string} weapon
  @param {number} texture ID
  @param {number} texture file width
  @param {number} texture file height
  @param {number} left u coordinate
  @param {number} top v coordinate
  @param {number} right u coordinate
  @param {number} bottom v coordinate
  @param {number|nil} x offset
  @param {number|nil} y offset
  @param {boolean|nil} is it scalable
]]--------------------------------------------------------------------
function SCHEME:AmmoSprite(ammo, texture, w, h, u1, v1, u2, v2, x, y, scalable)
  self:AddSprite(self.settings.HudTextures.AmmoInv, ammo, texture, w, h, u1, v1, u2, v2, x, y, scalable)
end

--[[------------------------------------------------------------------
  Removes an ammunition icon from the indicator.
  @param {string} ammunition name
]]--------------------------------------------------------------------
function SCHEME:RemoveAmmoIcon(ammo)
  self.settings.HudTextures.AmmoInv[ammo] = -1
end

--[[------------------------------------------------------------------
  Adds an entity pickup icon.
  @param {string} entity class
  @param {string} scheme font
  @param {string} character
  @param {number|nil} x offset
  @param {number|nil} y offset
]]--------------------------------------------------------------------
function SCHEME:EntityPickup(entity, font, icon, x, y)
  self:AddIcon(self.settings.HudTextures.Entities, entity, font, icon, x, y)
end

--[[------------------------------------------------------------------
  Adds an entity pickup icon sprite.
  @param {string} entity class
  @param {number} texture ID
  @param {number} texture file width
  @param {number} texture file height
  @param {number} left u coordinate
  @param {number} top v coordinate
  @param {number} right u coordinate
  @param {number} bottom v coordinate
  @param {number|nil} x offset
  @param {number|nil} y offset
  @param {boolean|nil} is it scalable
]]--------------------------------------------------------------------
function SCHEME:EntityPickupSprite(entity, texture, w, h, u1, v1, u2, v2, x, y, scalable)
  self:AddSprite(self.settings.HudTextures.Entities, entity, texture, w, h, u1, v1, u2, v2, x, y, scalable)
end

--[[------------------------------------------------------------------
  Removes an entity pickup icon.
  @param {string} entity class
]]--------------------------------------------------------------------
function SCHEME:RemoveEntityPickup(class)
  self.settings.HudTextures.Entities[class] = -1
end

--[[------------------------------------------------------------------
  Adds an ammunition pickup icon.
  @param {string} ammunition name
  @param {string} scheme font
  @param {string} character
  @param {number|nil} x offset
  @param {number|nil} y offset
]]--------------------------------------------------------------------
function SCHEME:AmmoPickup(ammo, font, icon, x, y)
  local data = self.settings.HudTextures.Ammo[ammo]
  local weapon
  if data then weapon = data.weapon end
  self:AddIcon(self.settings.HudTextures.Ammo, ammo, font, icon, x, y).weapon = weapon
end

--[[------------------------------------------------------------------
  Adds an ammunition pickup icon sprite.
  @param {string} ammunition name
  @param {number} texture ID
  @param {number} texture file width
  @param {number} texture file height
  @param {number} left u coordinate
  @param {number} top v coordinate
  @param {number} right u coordinate
  @param {number} bottom v coordinate
  @param {number|nil} x offset
  @param {number|nil} y offset
  @param {boolean|nil} is it scalable
]]--------------------------------------------------------------------
function SCHEME:AmmoPickupSprite(ammo, texture, w, h, u1, v1, u2, v2, x, y, scalable)
  local data = self.settings.HudTextures.Ammo[ammo]
  local weapon
  if data then weapon = data.weapon end
  self:AddSprite(self.settings.HudTextures.Ammo, ammo, texture, w, h, u1, v1, u2, v2, x, y, scalable).weapon = weapon
end

--[[------------------------------------------------------------------
  Removes an ammo pickup icon.
  @param {string} ammunition name
]]--------------------------------------------------------------------
function SCHEME:RemoveAmmoPickup(ammo)
  self.settings.HudTextures.Ammo[ammo] = -1
end

--[[------------------------------------------------------------------
  Adds a complementary weapon icon to the ammo pickup one.
  @param {string} ammunition name
  @param {string} scheme font
  @param {string} character
  @param {number|nil} x offset
  @param {number|nil} y offset
]]--------------------------------------------------------------------
function SCHEME:AmmoWeaponIcon(ammo, font, icon, x, y)
  self:AddIcon(self.settings.HudTextures.AmmoWep, ammo, font, icon, x, y)
end

--[[------------------------------------------------------------------
  Adds a complementary weapon icon sprite to the ammo pickup one.
  @param {string} ammunition name
  @param {number} texture ID
  @param {number} texture file width
  @param {number} texture file height
  @param {number} left u coordinate
  @param {number} top v coordinate
  @param {number} right u coordinate
  @param {number} bottom v coordinate
  @param {number|nil} x offset
  @param {number|nil} y offset
  @param {boolean|nil} is it scalable
]]--------------------------------------------------------------------
function SCHEME:AmmoWeaponSprite(ammo, texture, w, h, u1, v1, u2, v2, x, y, scalable)
  self:AddSprite(self.settings.HudTextures.AmmoWep, ammo, texture, w, h, u1, v1, u2, v2, x, y, scalable)
end

--[[------------------------------------------------------------------
  Removes the weapon icon assigned to the ammo pickup.
  @param {string} ammunition name
]]--------------------------------------------------------------------
function SCHEME:RemoveAmmoWeapon(ammo)
  self.settings.HudTextures.AmmoWep[ammo] = -1
end

--[[------------------------------------------------------------------
  Adds an animation sequence.
  @param {string} sequence
  @param {table} commands
]]--------------------------------------------------------------------
function SCHEME:Sequence(sequence, commands)
  local translated = {}
  for _, cmd in pairs(commands) do
    table.insert(translated, ParseCommand(cmd))
  end
  self.settings.HudAnimations[sequence] = translated
end

--[[------------------------------------------------------------------
  Sets the animation table.
  @param {table} animations
]]--------------------------------------------------------------------
function SCHEME:Animations(animations)
  for sequence, commands in pairs(animations) do
    self.settings.HudAnimations[sequence] = {}
    for _, cmd in pairs(commands) do -- parse animations
      table.insert(self.settings.HudAnimations[sequence], ParseCommand(cmd))
    end
  end
end

--[[------------------------------------------------------------------
  Creates (and returns) a copy of the scheme data table.
  @return {table} new data table
]]--------------------------------------------------------------------
function HL2HUD.scheme.CreateDataTable()
  return table.Copy(DATA_TABLE)
end

--[[------------------------------------------------------------------
  Returns a blank scheme.
  @return {table} blank scheme
]]--------------------------------------------------------------------
function HL2HUD.scheme.Create()
  return table.Copy(SCHEME)
end

--[[------------------------------------------------------------------
  Returns the fallback scheme.
  @param {table} default scheme
]]--------------------------------------------------------------------
function HL2HUD.scheme.GetDefault()
  return schemes[HL2HUD.scheme.default]
end

--[[------------------------------------------------------------------
  Registers a scheme.
  @param {string} scheme name
  @param {table} scheme data
  @param {boolean} is it user defined
]]--------------------------------------------------------------------
function HL2HUD.scheme.Register(name, scheme, userDefined)
  if not HL2HUD.scheme.default then
    if not scheme.default then error('No default scheme was found. Please add a default scheme before adding new ones.') end
  else
    if scheme.default then ErrorNoHaltWithStack('Unable to add scheme', name, '. Default scheme cannot be overwritten.') return end
  end

  -- register as default
  if scheme.default then
    userDefined = false
    HL2HUD.scheme.default = name
  end

  -- only settings are kept
  if scheme.settings then scheme = scheme.settings end

  -- register scheme
  scheme.engine = not userDefined
  schemes[name] = scheme
end

--[[------------------------------------------------------------------
  Removes a user defined scheme.
  @param {string} scheme name
]]--------------------------------------------------------------------
function HL2HUD.scheme.Remove(name)
  if schemes[name].engine then return end
  schemes[name] = nil
end

--[[------------------------------------------------------------------
  Returns the given scheme.
  @return {table} scheme data
]]--------------------------------------------------------------------
function HL2HUD.scheme.Get(scheme)
  return schemes[scheme]
end

--[[------------------------------------------------------------------
  Returns whether the scheme exists.
  @return {boolean} does the scheme exist
]]--------------------------------------------------------------------
function HL2HUD.scheme.Exists(scheme)
  return schemes[scheme] ~= nil
end

--[[------------------------------------------------------------------
  Returns all registered schemes.
  @return {table} schemes
]]--------------------------------------------------------------------
function HL2HUD.scheme.All()
  return schemes
end
