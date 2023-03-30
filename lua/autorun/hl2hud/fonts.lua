if SERVER then return end

HL2HUD.fonts = {} -- namespace

local fonts = {} -- registered fonts

--[[------------------------------------------------------------------
  Returns the HUD scale.
  @return {number} scale
]]--------------------------------------------------------------------
function HL2HUD.Scale()
  return ScrH() / 480
end

--[[------------------------------------------------------------------
  Creates an engine font with the given font's details.
  @param {string} font
]]--------------------------------------------------------------------
function HL2HUD.fonts.Create(name)
  local font = fonts[name] -- fetch font details
  local scale = HL2HUD.Scale()
  if not font.scalable then scale = 1 end
  surface.CreateFont(name, {
    font = font.font,
    size = math.ceil(font.size * scale),
    weight = font.weight,
    additive = font.additive,
    blursize = (font.blur or 0) * scale,
    scanlines = (font.scanlines or 0) * scale,
    symbol = font.symbol,
    antialias = font.antialias
  })
end

--[[------------------------------------------------------------------
  Adds a new scalable font.
  @param {string} name
  @param {string} font family
  @param {number} default size
  @param {number} weight
  @param {boolean} additive
  @param {number} blur
  @param {number} scanlines
  @param {boolean} is symbolic font
  @param {boolean} scalable
  @param {boolean} antialias
]]--------------------------------------------------------------------
function HL2HUD.fonts.Add(name, font, size, weight, additive, blur, scanlines, symbol, scalable, antialias)
  fonts[name] = {
    name = name,
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
  HL2HUD.fonts.Create(name)
end

--[[------------------------------------------------------------------
  Generates all registered fonts.
]]--------------------------------------------------------------------
function HL2HUD.fonts.Generate()
  for font, _ in pairs(fonts) do
    HL2HUD.fonts.Create(font)
  end
end

--[[------------------------------------------------------------------
  Regenerates all fonts when changing screen sizes.
]]--------------------------------------------------------------------
hook.Add('OnScreenSizeChanged', HL2HUD.hookname .. '_fonts', function() HL2HUD.fonts.Generate() end)
