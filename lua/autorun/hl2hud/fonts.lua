if SERVER then return end

HL2HUD.fonts = {} -- namespace

HL2HUD.FONTSCALING_NONE       = 0
HL2HUD.FONTSCALING_LIMITED    = 1
HL2HUD.FONTSCALING_UNLIMITED  = 2

local fonts = {} -- registered fonts

--[[------------------------------------------------------------------
  Returns the HUD scale.
  @return {number} scale
]]--------------------------------------------------------------------
local hl2hud_limiter = CreateClientConVar('hl2hud_limitscale', 1, true)
function HL2HUD.Scale()
  if not hl2hud_limiter:GetBool() then return ScrH() / 480 end
  return math.min(ScrH(), 1080) / 480
end

--[[------------------------------------------------------------------
  Creates an engine font with the given font's details.
  @param {string} font
]]--------------------------------------------------------------------
function HL2HUD.fonts.Create(name)
  local font = fonts[name] -- fetch font details
  local scale = HL2HUD.Scale()

  if font.scaling == HL2HUD.FONTSCALING_NONE then
    scale = 1
  elseif font.scaling == HL2HUD.FONTSCALING_LIMITED then
    scale = math.min(scale, 1080 / 480)
  end

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
  @param {HL2HUD.FONTSCALING} scaling
  @param {boolean} antialias
]]--------------------------------------------------------------------
function HL2HUD.fonts.Add(name, font, size, weight, additive, blur, scanlines, symbol, scaling, antialias)
  if isbool(scaling) then scaling = scaling and HL2HUD.FONTSCALING_UNLIMITED or HL2HUD.FONTSCALING_NONE end -- retro-compatibility with pre 1.10
  fonts[name] = {
    name = name,
    font = font,
    size = size,
    weight = weight,
    additive = additive,
    blur = blur,
    scanlines = scanlines,
    symbol = symbol,
    scaling = scaling,
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

--[[------------------------------------------------------------------
  Regenerates all fonts when toggling the scale limiter.
]]--------------------------------------------------------------------
cvars.AddChangeCallback('hl2hud_limitscale', function(_, _, _) HL2HUD.fonts.Generate() end)