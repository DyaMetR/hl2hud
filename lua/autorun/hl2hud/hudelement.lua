--[[------------------------------------------------------------------
  HUD elements API.

  -- TODO: explain API
]]--------------------------------------------------------------------

if SERVER then return end

HL2HUD.elements = {} -- namespace

HL2HUD.elements.PARAM_NUMBER  = 1
HL2HUD.elements.PARAM_STRING  = 2
HL2HUD.elements.PARAM_COLOUR  = 3
HL2HUD.elements.PARAM_FONT    = 4
HL2HUD.elements.PARAM_BOOLEAN = 5
HL2HUD.elements.PARAM_OPTION  = 6

local elements = {} -- registered HUD elements
local hidden = {} -- default HUD elements being hidden (and who hides them)

local ELEMENT = { i = 0, parameters = {}, fonts = {}, variables = {} }

--[[------------------------------------------------------------------
  Sets whether this element should be drawn on PostDraw instead, to
  override HUDShouldDraw.
  @param {boolean} set to be drawn on the overlay
]]--------------------------------------------------------------------
function ELEMENT:SetDrawOnTop(draw)
  self.OnTop = draw
end

--[[------------------------------------------------------------------
  Declares a new blank parameter.
  @param {string} name
  @param {PARAM_} parameter type
  @return {table} generated parameter
]]--------------------------------------------------------------------
function ELEMENT:Parameter(name, type)
  local parameter = { name = name, i = table.Count(self.parameters) + 1, type = type }
  self.parameters[name] = parameter
  return parameter
end

--[[------------------------------------------------------------------
  Declares a numeric parameter.
  @param {string} name
  @return {table} generated parameter
]]--------------------------------------------------------------------
function ELEMENT:Number(name)
  return self:Parameter(name, HL2HUD.elements.PARAM_NUMBER)
end

--[[------------------------------------------------------------------
  Declares a text parameter.
  @param {string} name
  @return {table} generated parameter
]]--------------------------------------------------------------------
function ELEMENT:String(name)
  return self:Parameter(name, HL2HUD.elements.PARAM_STRING)
end

--[[------------------------------------------------------------------
  Declares a colour parameter.
  @param {string} name
  @return {table} generated parameter
]]--------------------------------------------------------------------
function ELEMENT:Colour(name)
  return self:Parameter(name, HL2HUD.elements.PARAM_COLOUR)
end

--[[------------------------------------------------------------------
  Declares a font parameter.
  @param {string} name
  @return {table} generated parameter
]]--------------------------------------------------------------------
function ELEMENT:Font(name)
  local parameter = self:Parameter(name, HL2HUD.elements.PARAM_FONT)
  parameter.font = string.format('hl2hud_%s_%s', self.name, name)
  self.fonts[name] = parameter.font
  return parameter
end

--[[------------------------------------------------------------------
  Declares a boolean parameter.
  @param {string} name
  @return {table} generated parameter
]]--------------------------------------------------------------------
function ELEMENT:Boolean(name)
  return self:Parameter(name, HL2HUD.elements.PARAM_BOOLEAN)
end

--[[------------------------------------------------------------------
  Declares an option parameter.
  @param {string} name
  @return {table} generated parameter
]]--------------------------------------------------------------------
function ELEMENT:Option(name, options)
  local parameter = self:Parameter(name, HL2HUD.elements.PARAM_OPTION)
  parameter.options = options
  return parameter
end

--[[------------------------------------------------------------------
  Declares an option parameter with alignment options.
  @param {string} name
  @return {table} generated parameter
]]--------------------------------------------------------------------
function ELEMENT:Alignment(name)
  return self:Option(name, { 'Begin', 'End' })
end

--[[------------------------------------------------------------------
  Assigns a value to a variable.
  @param {string} name
  @param {any} value
]]--------------------------------------------------------------------
function ELEMENT:Variable(name, value)
  self.variables[name] = value
end

--[[------------------------------------------------------------------
  Called when the element is initialized.
  @param {table} element settings
]]--------------------------------------------------------------------
function ELEMENT:Init(settings) end

--[[------------------------------------------------------------------
  Returns whether the HUD element should be drawn, replacing its
  default counterpart.
  @param {table} element settings
  @return {boolean} should draw
]]--------------------------------------------------------------------
function ELEMENT:ShouldDraw(settings) return true end

--[[------------------------------------------------------------------
  Called before drawing the element outside of a rendering context.
  @param {table} element settings
]]--------------------------------------------------------------------
function ELEMENT:PreDraw(settings) end

--[[------------------------------------------------------------------
  Ran alongside the Paint function. Reserved for animation logic.
  @param {table} element settings
]]--------------------------------------------------------------------
function ELEMENT:OnThink(settings) end

--[[------------------------------------------------------------------
  Paints the HUD on the screen.
  @param {table} element settings
  @param {number} scale
]]--------------------------------------------------------------------
function ELEMENT:Draw(settings, scale) end

--[[------------------------------------------------------------------
  Registers a new HUD element and returns the created table.
  @param {string} name
  @param {string} CHudElement that replaces
]]--------------------------------------------------------------------
function HL2HUD.elements.Register(name, hide)
  local settings = HL2HUD.settings.Get()
  local element = table.Copy(ELEMENT)
  element.name = name
  element.hide = hide
  elements[name] = element
  element.i = table.Count(elements)
  element.colours = settings.ClientScheme.Colors
  element.icons = settings.HudTextures
  hidden[hide] = element
  return element
end

--[[------------------------------------------------------------------
  Initializes all HUD elements.
  @param {table} scheme
]]--------------------------------------------------------------------
function HL2HUD.elements.Init(scheme)
  for i, element in pairs(elements) do
    element:Init(scheme.HudLayout[i])
  end
end

--[[------------------------------------------------------------------
  Gets a HUD element.
  @param {string} name
  @return {table} element
]]--------------------------------------------------------------------
function HL2HUD.elements.Get(name)
  return elements[name]
end

--[[------------------------------------------------------------------
  Returns all HUD elements.
  @return {table} elements
]]--------------------------------------------------------------------
function HL2HUD.elements.All()
  return elements
end

--[[------------------------------------------------------------------
  Returns the element table which is replacing the given CHud element.
  @param {string} CHud element name
  @return {table} replacer
]]--------------------------------------------------------------------
function HL2HUD.elements.CHudReplacer(hide)
  return hidden[hide]
end

--[[------------------------------------------------------------------
  Creates an iterator for the elements.
  @return {function} iterator function
  @return {table} table used by the iterator
]]--------------------------------------------------------------------
function HL2HUD.elements.Iterator()
  return SortedPairsByMemberValue(elements, 'i', true)
end