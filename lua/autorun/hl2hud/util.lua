
if SERVER then return end

HL2HUD.utils = {
  DefaultIcons = {
    ammo = {
      Pistol = 'p',
      ['357'] = 'q',
      SMG1 = 'r',
      SMG1_Grenade = 't',
      AR2 = 'u',
      AR2AltFire = 'z',
      Buckshot = 's',
      XBowBolt = 'w',
      Grenade = 'v',
      RPG_Round = 'x'
    },
    weapons = {
      weapon_physcannon = 'm',
      weapon_physgun = 'h',
      weapon_crowbar = 'c',
      weapon_stunstick = 'n',
      weapon_pistol = 'd',
      weapon_357 = 'e',
      weapon_smg1 = 'a',
      weapon_ar2 = 'l',
      weapon_shotgun = 'b',
      weapon_crossbow = 'g',
      weapon_frag = 'k',
      weapon_rpg = 'i',
      weapon_bugbait = 'j',
      weapon_slam = 'o'
    },
    ammoWeapon = {
      Pistol = 'weapon_pistol',
      ['357'] = 'weapon_357',
      SMG1 = 'weapon_smg1',
      SMG1_Grenade = 'weapon_smg1',
      AR2 = 'weapon_ar2',
      AR2AltFire = 'weapon_ar2',
      Buckshot = 'weapon_shotgun',
      XBowBolt = 'weapon_crossbow',
      RPG_Round = 'weapon_rpg'
    }
  },
  AltIcons = {
    weapon_physcannon = ',',
    weapon_physgun = ',',
    weapon_crowbar = '6',
    weapon_pistol = '-',
    weapon_357 = '.',
    weapon_smg1 = '/',
    weapon_ar2 = '2',
    weapon_shotgun = '0',
    weapon_crossbow = '1',
    weapon_frag = '4',
    weapon_rpg = '3',
    weapon_stunstick = '!',
    weapon_bugbait = '5',
    weapon_slam = '*'
  }
}

--[[------------------------------------------------------------------
	Merges the interpolation of two tables into the target table.
	@param {table} starting table
	@param {table} ending table
	@param {table} target table
	@param {number} how much of the ending table's values is merged into the result
]]--------------------------------------------------------------------
function HL2HUD.utils.InterpolateTableValues(startTable, endTable, target, amount)
	for i, value in pairs(target) do
		target[i] = (startTable[i] * (1 - amount)) + (endTable[i] * amount)
	end
end

--[[------------------------------------------------------------------
	Draws a text that can glow.
	@param {table} glow controller
	@param {string} text
	@param {string} font for foreground
	@param {string} font for glow
	@param {number} x
	@param {number} y
	@param {Color} colour for foreground
	@param {Color} colour for glow
	@param {TEXT_ALIGN_} horizontal alignment
	@param {TEXT_ALIGN_} vertical alignment
]]--------------------------------------------------------------------
function HL2HUD.utils.DrawGlowingText(glow, text, font, fontGlow, x, y, colour, colourGlow, halign, valign)
	draw.SimpleText(text, font, x, y, colour, halign, valign)
	if glow <= 0 then return end
  local prev = surface.GetAlphaMultiplier()
	for i=1, math.ceil(glow) do
		surface.SetAlphaMultiplier(prev * (glow - (i - 1)))
		draw.SimpleText(text, fontGlow, x, y, colourGlow, halign, valign)
	end
  surface.SetAlphaMultiplier(prev)
end

--[[------------------------------------------------------------------
	Draws the given icon.
  @param {table} icon data
  @param {number} x
  @param {number} y
  @param {number} scale applied to offset
  @param {Color} colour
  @param {TEXT_ALIGN_} horizontal alignment
  @param {TEXT_ALIGN_} vertical alignment
  @param {number|nil} width (in case of sprites)
  @param {number|nil} height (in case of sprites)
]]--------------------------------------------------------------------
function HL2HUD.utils.DrawIcon(data, x, y, colour, halign, valign, w, h)
  local scale = HL2HUD.Scale()
  x = x + data.x * scale
  y = y + data.y * scale
  if data.type == HL2HUD.scheme.ICON_FONT then
    draw.SimpleText(data.icon, string.format(HL2HUD.scheme.ICON_FORMAT, data.font), x, y, colour, halign, valign)
  else
    if not data.scalable then scale = 1 end
    local u1, v1, u2, v2 = data.u1 or 0, data.v1 or 0, data.u2 or data.w, data.v2 or data.h
    w = (w or (u2 - u1)) * scale
    h = (h or (v2 - v1)) * scale
    if halign == TEXT_ALIGN_CENTER then
      x = x - w * .5
    elseif halign == TEXT_ALIGN_RIGHT then
      x = x - w
    end
    if valign == TEXT_ALIGN_CENTER then
      y = y - h * .5
    elseif halign == TEXT_ALIGN_BOTTOM then
      y = y - h
    end
    surface.SetDrawColor(colour)
    surface.SetTexture(data.texture)
    surface.DrawTexturedRectUV(x, y, w, h, u1 / data.w, v1 / data.h, u2 / data.w, v2 / data.h)
  end
end

--[[------------------------------------------------------------------
	Returns the size of the given icon.
  @param {table} icon data
  @return {number} width
  @return {number} height
]]--------------------------------------------------------------------
function HL2HUD.utils.GetIconSize(icon)
  if icon.type == HL2HUD.scheme.ICON_FONT then
    surface.SetFont(string.format(HL2HUD.scheme.ICON_FORMAT, icon.font))
    return surface.GetTextSize(icon.icon)
  else
    local scale = HL2HUD.Scale()
    if not icon.scalable then scale = 1 end
    local u1, v1, u2, v2 = icon.u1 or 0, icon.v1 or 0, icon.u2 or icon.w, icon.v2 or icon.h
    return (u2 - u1) * scale, (v2 - v1) * scale
  end
end

--[[------------------------------------------------------------------
  Merges two tables overwriting children with the same name.
  @param {table} destination
  @param {table} source
]]--------------------------------------------------------------------
function HL2HUD.utils.MergeTables(destination, source)
  for k, v in pairs(source) do
    if istable(v) then v = table.Copy(v) end
    destination[k] = v
  end
end

--[[------------------------------------------------------------------
  Deep copies the colours of the source table into the destination table.
  @param {table} destination
  @param {table} source
]]--------------------------------------------------------------------
function HL2HUD.utils.MergeColours(destination, source)
  for name, colour in pairs(source) do
    destination[name] = Color(colour.r, colour.g, colour.b, colour.a)
  end
end

--[[------------------------------------------------------------------
  Merges two scheme tables.
  @param {table} scheme to change
  @param {table} scheme table to apply
]]--------------------------------------------------------------------
function HL2HUD.utils.MergeSchemeLayers(destination, scheme)
  if scheme.HudLayout then
    for element, parameters in pairs(scheme.HudLayout) do
      if not destination.HudLayout[element] then continue end
      HL2HUD.utils.MergeTables(destination.HudLayout[element], parameters)
    end
  end
  if scheme.HudAnimations then HL2HUD.utils.MergeTables(destination.HudAnimations, scheme.HudAnimations) end
  if scheme.HudTextures then
    for category, textures in pairs(scheme.HudTextures) do
      if not destination.HudTextures[category] then continue end
      for class, texture in pairs(textures) do -- manually check for NULL textures to remove them from the scheme
        if texture ~= -1 then
          destination.HudTextures[category][class] = table.Copy(scheme.HudTextures[category][class])
        else
          destination.HudTextures[category][class] = nil
        end
      end
    end
  end
  if scheme.ClientScheme then
    if scheme.ClientScheme.Colors then HL2HUD.utils.MergeColours(destination.ClientScheme.Colors, scheme.ClientScheme.Colors) end
    if scheme.ClientScheme.Fonts then HL2HUD.utils.MergeTables(destination.ClientScheme.Fonts, scheme.ClientScheme.Fonts) end
  end
end
